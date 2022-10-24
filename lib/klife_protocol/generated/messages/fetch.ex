# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.Fetch do
  @moduledoc """
  Kafka protocol Fetch message

  Request versions summary:   
  - Version 1 is the same as version 0.
  - Starting in Version 2, the requestor must be able to handle Kafka Log
  Message format version 1.
  - Version 3 adds MaxBytes.  Starting in version 3, the partition ordering in
  the request is now relevant.  Partitions will be processed in the order
  they appear in the request.
  - Version 4 adds IsolationLevel.  Starting in version 4, the reqestor must be
  able to handle Kafka log message format version 2.
  - Version 5 adds LogStartOffset to indicate the earliest available offset of
  partition data that can be consumed.
  - Version 6 is the same as version 5.
  - Version 7 adds incremental fetch request support.
  - Version 8 is the same as version 7.
  - Version 9 adds CurrentLeaderEpoch, as described in KIP-320.
  - Version 10 indicates that we can use the ZStd compression algorithm, as
  described in KIP-110.
  Version 12 adds flexible versions support as well as epoch validation through
  the `LastFetchedEpoch` field
  - Version 13 replaces topic names with topic IDs (KIP-516). May return UNKNOWN_TOPIC_ID error code.

  Response versions summary:
  - Version 1 adds throttle time.
  - Version 2 and 3 are the same as version 1.
  - Version 4 adds features for transactional consumption.
  - Version 5 adds LogStartOffset to indicate the earliest available offset of
  partition data that can be consumed.
  - Starting in version 6, we may return KAFKA_STORAGE_ERROR as an error code.
  - Version 7 adds incremental fetch request support.
  - Starting in version 8, on quota violation, brokers send out responses before throttling.
  - Version 9 is the same as version 8.
  - Version 10 indicates that the response data can use the ZStd compression
  algorithm, as described in KIP-110.
  Version 12 adds support for flexible versions, epoch detection through the `TruncationOffset` field,
  and leader discovery through the `CurrentLeader` field
  - Version 13 replaces the topic name field with topic ID (KIP-516).

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 1
  @min_flexible_version_req 12
  @min_flexible_version_res 12

  @doc """
  Valid fields:

  - cluster_id: The clusterId if known. This is used to validate metadata fetches prior to broker registration. (string | versions 12+)
  - replica_id: The broker ID of the follower, of -1 if this request is from a consumer. (int32 | versions 0+)
  - max_wait_ms: The maximum time in milliseconds to wait for the response. (int32 | versions 0+)
  - min_bytes: The minimum bytes to accumulate in the response. (int32 | versions 0+)
  - max_bytes: The maximum bytes to fetch.  See KIP-74 for cases where this limit may not be honored. (int32 | versions 3+)
  - isolation_level: This setting controls the visibility of transactional records. Using READ_UNCOMMITTED (isolation_level = 0) makes all records visible. With READ_COMMITTED (isolation_level = 1), non-transactional and COMMITTED transactional records are visible. To be more concrete, READ_COMMITTED returns all data from offsets smaller than the current LSO (last stable offset), and enables the inclusion of the list of aborted transactions in the result, which allows consumers to discard ABORTED transactional records (int8 | versions 4+)
  - session_id: The fetch session ID. (int32 | versions 7+)
  - session_epoch: The fetch session epoch, which is used for ordering requests in a session. (int32 | versions 7+)
  - topics: The topics to fetch. ([]FetchTopic | versions 0+)
  - topic: The name of the topic to fetch. (string | versions 0-12) 
  - topic_id: The unique topic ID (uuid | versions 13+) 
  - partitions: The partitions to fetch. ([]FetchPartition | versions 0+) 
  - partition: The partition index. (int32 | versions 0+) 
  - current_leader_epoch: The current leader epoch of the partition. (int32 | versions 9+) 
  - fetch_offset: The message offset. (int64 | versions 0+) 
  - last_fetched_epoch: The epoch of the last fetched record or -1 if there is none (int32 | versions 12+) 
  - log_start_offset: The earliest available offset of the follower replica.  The field is only used when the request is sent by the follower. (int64 | versions 5+) 
  - partition_max_bytes: The maximum bytes to fetch from this partition.  See KIP-74 for cases where this limit may not be honored. (int32 | versions 0+) 
  - forgotten_topics_data: In an incremental fetch request, the partitions to remove. ([]ForgottenTopic | versions 7+)
  - topic: The topic name. (string | versions 7-12) 
  - topic_id: The unique topic ID (uuid | versions 13+) 
  - partitions: The partitions indexes to forget. ([]int32 | versions 7+) 
  - rack_id: Rack ID of the consumer making this request (string | versions 11+)

  """
  def serialize_request(%{headers: headers, content: content}, version) do
    headers
    |> Map.put(:request_api_key, @api_key)
    |> Map.put(:request_api_version, version)
    |> Header.serialize_request(req_header_version(version))
    |> then(&Serializer.execute(content, request_schema(version), &1))
  end

  @doc """
  Valid fields:

  - throttle_time_ms: The duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 1+)
  - error_code: The top level response error code. (int16 | versions 7+)
  - session_id: The fetch session ID, or 0 if this is not part of a fetch session. (int32 | versions 7+)
  - responses: The response topics. ([]FetchableTopicResponse | versions 0+)
      - topic: The topic name. (string | versions 0-12)
      - topic_id: The unique topic ID (uuid | versions 13+)
      - partitions: The topic partitions. ([]PartitionData | versions 0+)
          - partition_index: The partition index. (int32 | versions 0+)
          - error_code: The error code, or 0 if there was no fetch error. (int16 | versions 0+)
          - high_watermark: The current high water mark. (int64 | versions 0+)
          - last_stable_offset: The last stable offset (or LSO) of the partition. This is the last offset such that the state of all transactional records prior to this offset have been decided (ABORTED or COMMITTED) (int64 | versions 4+)
          - log_start_offset: The current log start offset. (int64 | versions 5+)
          - diverging_epoch: In case divergence is detected based on the `LastFetchedEpoch` and `FetchOffset` in the request, this field indicates the largest epoch and its end offset such that subsequent records are known to diverge (EpochEndOffset | versions 12+)
              - epoch:  (int32 | versions 12+)
              - end_offset:  (int64 | versions 12+)
          - current_leader:  (LeaderIdAndEpoch | versions 12+)
              - leader_id: The ID of the current leader or -1 if the leader is unknown. (int32 | versions 12+)
              - leader_epoch: The latest known leader epoch (int32 | versions 12+)
          - snapshot_id: In the case of fetching an offset less than the LogStartOffset, this is the end offset and epoch that should be used in the FetchSnapshot request. (SnapshotId | versions 12+)
              - end_offset:  (int64 | versions 0+)
              - epoch:  (int32 | versions 0+)
          - aborted_transactions: The aborted transactions. ([]AbortedTransaction | versions 4+)
              - producer_id: The producer id associated with the aborted transaction. (int64 | versions 4+)
              - first_offset: The first offset in the aborted transaction. (int64 | versions 4+)
          - preferred_read_replica: The preferred read replica for the consumer to use on its next fetch request (int32 | versions 11+)
          - records: The record data. (records | versions 0+)

  """
  def deserialize_response(data, version) do
    {headers, rest_data} = Header.deserialize_response(data, res_header_version(version))
    {content, <<>>} = Deserializer.execute(rest_data, response_schema(version))

    %{headers: headers, content: content}
  end

  defp req_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_req, do: 2, else: 1)

  defp res_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_res, do: 1, else: 0)

  defp request_schema(0),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(1),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(2),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(3),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(4),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(5),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(6),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(7),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      session_epoch: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      forgotten_topics_data:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(8),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      session_epoch: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      forgotten_topics_data:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(9),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      session_epoch: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      forgotten_topics_data:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(10),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      session_epoch: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      forgotten_topics_data:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(11),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      session_epoch: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      forgotten_topics_data:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      rack_id: {:string, %{is_nullable?: false}}
    ]

  defp request_schema(12),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      session_epoch: {:int32, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            topic: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  last_fetched_epoch: {:int32, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      forgotten_topics_data:
        {{:compact_array,
          [
            topic: {:compact_string, %{is_nullable?: false}},
            partitions: {{:compact_array, :int32}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      rack_id: {:compact_string, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, [cluster_id: {{0, :compact_string}, %{is_nullable?: true}}]}
    ]

  defp request_schema(13),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      max_wait_ms: {:int32, %{is_nullable?: false}},
      min_bytes: {:int32, %{is_nullable?: false}},
      max_bytes: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      session_epoch: {:int32, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            topic_id: {:uuid, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  fetch_offset: {:int64, %{is_nullable?: false}},
                  last_fetched_epoch: {:int32, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  partition_max_bytes: {:int32, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      forgotten_topics_data:
        {{:compact_array,
          [
            topic_id: {:uuid, %{is_nullable?: false}},
            partitions: {{:compact_array, :int32}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      rack_id: {:compact_string, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, [cluster_id: {{0, :compact_string}, %{is_nullable?: true}}]}
    ]

  defp response_schema(0),
    do: [
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(1),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(2),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(3),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(4),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(5),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(6),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(7),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(8),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(9),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(10),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(11),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      responses:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}}
                      ]}, %{is_nullable?: true}},
                  preferred_read_replica: {:int32, %{is_nullable?: false}},
                  records: {:records, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(12),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      responses:
        {{:compact_array,
          [
            topic: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:compact_array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}},
                        tag_buffer: {:tag_buffer, %{}}
                      ]}, %{is_nullable?: true}},
                  preferred_read_replica: {:int32, %{is_nullable?: false}},
                  records: {:records, %{is_nullable?: true}},
                  tag_buffer:
                    {:tag_buffer,
                     %{
                       0 =>
                         {{:diverging_epoch,
                           {:object,
                            [
                              epoch: {:int32, %{is_nullable?: false}},
                              end_offset: {:int64, %{is_nullable?: false}},
                              tag_buffer: {:tag_buffer, %{}}
                            ]}}, %{is_nullable?: false}},
                       1 =>
                         {{:current_leader,
                           {:object,
                            [
                              leader_id: {:int32, %{is_nullable?: false}},
                              leader_epoch: {:int32, %{is_nullable?: false}},
                              tag_buffer: {:tag_buffer, %{}}
                            ]}}, %{is_nullable?: false}},
                       2 =>
                         {{:snapshot_id,
                           {:object,
                            [
                              end_offset: {:int64, %{is_nullable?: false}},
                              epoch: {:int32, %{is_nullable?: false}},
                              tag_buffer: {:tag_buffer, %{}}
                            ]}}, %{is_nullable?: false}}
                     }}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(13),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      session_id: {:int32, %{is_nullable?: false}},
      responses:
        {{:compact_array,
          [
            topic_id: {:uuid, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  high_watermark: {:int64, %{is_nullable?: false}},
                  last_stable_offset: {:int64, %{is_nullable?: false}},
                  log_start_offset: {:int64, %{is_nullable?: false}},
                  aborted_transactions:
                    {{:compact_array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        first_offset: {:int64, %{is_nullable?: false}},
                        tag_buffer: {:tag_buffer, %{}}
                      ]}, %{is_nullable?: true}},
                  preferred_read_replica: {:int32, %{is_nullable?: false}},
                  records: {:records, %{is_nullable?: true}},
                  tag_buffer:
                    {:tag_buffer,
                     %{
                       0 =>
                         {{:diverging_epoch,
                           {:object,
                            [
                              epoch: {:int32, %{is_nullable?: false}},
                              end_offset: {:int64, %{is_nullable?: false}},
                              tag_buffer: {:tag_buffer, %{}}
                            ]}}, %{is_nullable?: false}},
                       1 =>
                         {{:current_leader,
                           {:object,
                            [
                              leader_id: {:int32, %{is_nullable?: false}},
                              leader_epoch: {:int32, %{is_nullable?: false}},
                              tag_buffer: {:tag_buffer, %{}}
                            ]}}, %{is_nullable?: false}},
                       2 =>
                         {{:snapshot_id,
                           {:object,
                            [
                              end_offset: {:int64, %{is_nullable?: false}},
                              epoch: {:int32, %{is_nullable?: false}},
                              tag_buffer: {:tag_buffer, %{}}
                            ]}}, %{is_nullable?: false}}
                     }}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]
end