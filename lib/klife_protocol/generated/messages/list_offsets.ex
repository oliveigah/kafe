# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.ListOffsets do
  @moduledoc """
  Kafka protocol ListOffsets message

  Request versions summary:   
  - Version 1 removes MaxNumOffsets.  From this version forward, only a single
  offset can be returned.
  - Version 2 adds the isolation level, which is used for transactional reads.
  - Version 3 is the same as version 2.
  - Version 4 adds the current leader epoch, which is used for fencing.
  - Version 5 is the same as version 4.
  - Version 6 enables flexible versions.
  - Version 7 enables listing offsets by max timestamp (KIP-734).
  - Version 8 enables listing offsets by local log start offset (KIP-405).

  Response versions summary:
  - Version 1 removes the offsets array in favor of returning a single offset.
  Version 1 also adds the timestamp associated with the returned offset.
  - Version 2 adds the throttle time.
  - Starting in version 3, on quota violation, brokers send out responses before throttling.
  - Version 4 adds the leader epoch, which is used for fencing.
  - Version 5 adds a new error code, OFFSET_NOT_AVAILABLE.
  - Version 6 enables flexible versions.
  - Version 7 is the same as version 6 (KIP-734).
  - Version 8 enables listing offsets by local log start offset.
  This is the earliest log start offset in the local log. (KIP-405).

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 2
  @min_flexible_version_req 6
  @min_flexible_version_res 6

  @doc """
  Receives a map and serialize it to kafka wire format of the given version.

  Input content fields:
  - replica_id: The broker ID of the requester, or -1 if this request is being made by a normal consumer. (int32 | versions 0+)
  - isolation_level: This setting controls the visibility of transactional records. Using READ_UNCOMMITTED (isolation_level = 0) makes all records visible. With READ_COMMITTED (isolation_level = 1), non-transactional and COMMITTED transactional records are visible. To be more concrete, READ_COMMITTED returns all data from offsets smaller than the current LSO (last stable offset), and enables the inclusion of the list of aborted transactions in the result, which allows consumers to discard ABORTED transactional records (int8 | versions 2+)
  - topics: Each topic in the request. ([]ListOffsetsTopic | versions 0+)
      - name: The topic name. (string | versions 0+)
      - partitions: Each partition in the request. ([]ListOffsetsPartition | versions 0+)
          - partition_index: The partition index. (int32 | versions 0+)
          - current_leader_epoch: The current leader epoch. (int32 | versions 4+)
          - timestamp: The current timestamp. (int64 | versions 0+)
          - max_num_offsets: The maximum number of offsets to report. (int32 | versions 0)

  """
  def serialize_request(%{headers: headers, content: content}, version) do
    headers
    |> Map.put(:request_api_key, @api_key)
    |> Map.put(:request_api_version, version)
    |> Header.serialize_request(req_header_version(version))
    |> then(&Serializer.execute(content, request_schema(version), &1))
  end

  @doc """
  Receive a binary in the kafka wire format and deserialize it into a map.

  Response content fields:

  - throttle_time_ms: The duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 2+)
  - topics: Each topic in the response. ([]ListOffsetsTopicResponse | versions 0+)
      - name: The topic name (string | versions 0+)
      - partitions: Each partition in the response. ([]ListOffsetsPartitionResponse | versions 0+)
          - partition_index: The partition index. (int32 | versions 0+)
          - error_code: The partition error code, or 0 if there was no error. (int16 | versions 0+)
          - old_style_offsets: The result offsets. ([]int64 | versions 0)
          - timestamp: The timestamp associated with the returned offset. (int64 | versions 1+)
          - offset: The returned offset. (int64 | versions 1+)
          - leader_epoch:  (int32 | versions 4+)

  """
  def deserialize_response(data, version, with_header? \\ true)

  def deserialize_response(data, version, true) do
    {:ok, {headers, rest_data}} = Header.deserialize_response(data, res_header_version(version))

    case Deserializer.execute(rest_data, response_schema(version)) do
      {:ok, {content, <<>>}} ->
        {:ok, %{headers: headers, content: content}}

      {:error, _reason} = err ->
        err
    end
  end

  def deserialize_response(data, version, false) do
    case Deserializer.execute(data, response_schema(version)) do
      {:ok, {content, <<>>}} ->
        {:ok, %{content: content}}

      {:error, _reason} = err ->
        err
    end
  end

  @doc """
  Returns the message api key number.
  """
  def api_key(), do: @api_key

  @doc """
  Returns the current max supported version of this message.
  """
  def max_supported_version(), do: 8

  @doc """
  Returns the current min supported version of this message.
  """
  def min_supported_version(), do: 0

  defp req_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_req, do: 2, else: 1)

  defp res_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_res, do: 1, else: 0)

  defp request_schema(0),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  max_num_offsets: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(1),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(2),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(3),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(4),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(5),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(6),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(7),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(8),
    do: [
      replica_id: {:int32, %{is_nullable?: false}},
      isolation_level: {:int8, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  current_leader_epoch: {:int32, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message ListOffsets")

  defp response_schema(0),
    do: [
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  old_style_offsets: {{:array, :int64}, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(1),
    do: [
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(2),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(3),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(4),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}},
                  leader_epoch: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(5),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}},
                  leader_epoch: {:int32, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(6),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}},
                  leader_epoch: {:int32, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(7),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}},
                  leader_epoch: {:int32, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(8),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  timestamp: {:int64, %{is_nullable?: false}},
                  offset: {:int64, %{is_nullable?: false}},
                  leader_epoch: {:int32, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message ListOffsets")
end