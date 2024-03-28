# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.OffsetFetch do
  @moduledoc """
  Kafka protocol OffsetFetch message

  Request versions summary:   
  - In version 0, the request read offsets from ZK.
  - Starting in version 1, the broker supports fetching offsets from the internal __consumer_offsets topic.
  - Starting in version 2, the request can contain a null topics array to indicate that offsets
  for all topics should be fetched. It also returns a top level error code
  for group or coordinator level errors.
  - Version 3, 4, and 5 are the same as version 2.
  - Version 6 is the first flexible version.
  - Version 7 is adding the require stable flag.
  - Version 8 is adding support for fetching offsets for multiple groups at a time.
  - Version 9 is the first version that can be used with the new consumer group protocol (KIP-848). It adds
  the MemberId and MemberEpoch fields. Those are filled in and validated when the new consumer protocol is used.

  Response versions summary:
  - Version 1 is the same as version 0.
  - Version 2 adds a top-level error code.
  - Version 3 adds the throttle time.
  - Starting in version 4, on quota violation, brokers send out responses before throttling.
  - Version 5 adds the leader epoch to the committed offset.
  - Version 6 is the first flexible version.
  - Version 7 adds pending offset commit as new error response on partition level.
  - Version 8 is adding support for fetching offsets for multiple groups
  - Version 9 is the first version that can be used with the new consumer group protocol (KIP-848). The response is
  the same as version 8 but can return STALE_MEMBER_EPOCH and UNKNOWN_MEMBER_ID errors when the new consumer group
  protocol is used.

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 9
  @min_flexible_version_req 6
  @min_flexible_version_res 6

  @doc """
  Receives a map and serialize it to kafka wire format of the given version.

  Input content fields:
  - group_id: The group to fetch offsets for. (string | versions 0-7)
  - topics: Each topic we would like to fetch offsets for, or null to fetch offsets for all topics. ([]OffsetFetchRequestTopic | versions 0-7)
      - name: The topic name. (string | versions 0-7)
      - partition_indexes: The partition indexes we would like to fetch offsets for. ([]int32 | versions 0-7)
  - groups: Each group we would like to fetch offsets for ([]OffsetFetchRequestGroup | versions 8+)
      - group_id: The group ID. (string | versions 8+)
      - member_id: The member ID assigned by the group coordinator if using the new consumer protocol (KIP-848). (string | versions 9+)
      - member_epoch: The member epoch if using the new consumer protocol (KIP-848). (int32 | versions 9+)
      - topics: Each topic we would like to fetch offsets for, or null to fetch offsets for all topics. ([]OffsetFetchRequestTopics | versions 8+)
          - name: The topic name. (string | versions 8+)
          - partition_indexes: The partition indexes we would like to fetch offsets for. ([]int32 | versions 8+)
  - require_stable: Whether broker should hold on returning unstable offsets but set a retriable error code for the partitions. (bool | versions 7+)

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

  - throttle_time_ms: The duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 3+)
  - topics: The responses per topic. ([]OffsetFetchResponseTopic | versions 0-7)
      - name: The topic name. (string | versions 0-7)
      - partitions: The responses per partition ([]OffsetFetchResponsePartition | versions 0-7)
          - partition_index: The partition index. (int32 | versions 0-7)
          - committed_offset: The committed message offset. (int64 | versions 0-7)
          - committed_leader_epoch: The leader epoch. (int32 | versions 5-7)
          - metadata: The partition metadata. (string | versions 0-7)
          - error_code: The error code, or 0 if there was no error. (int16 | versions 0-7)
  - error_code: The top-level error code, or 0 if there was no error. (int16 | versions 2-7)
  - groups: The responses per group id. ([]OffsetFetchResponseGroup | versions 8+)
      - group_id: The group ID. (string | versions 8+)
      - topics: The responses per topic. ([]OffsetFetchResponseTopics | versions 8+)
          - name: The topic name. (string | versions 8+)
          - partitions: The responses per partition ([]OffsetFetchResponsePartitions | versions 8+)
              - partition_index: The partition index. (int32 | versions 8+)
              - committed_offset: The committed message offset. (int64 | versions 8+)
              - committed_leader_epoch: The leader epoch. (int32 | versions 8+)
              - metadata: The partition metadata. (string | versions 8+)
              - error_code: The partition-level error code, or 0 if there was no error. (int16 | versions 8+)
      - error_code: The group-level error code, or 0 if there was no error. (int16 | versions 8+)

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
  def max_supported_version(), do: 9

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
      group_id: {:string, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partition_indexes: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(1),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partition_indexes: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(2),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partition_indexes: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: true}}
    ]

  defp request_schema(3),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partition_indexes: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: true}}
    ]

  defp request_schema(4),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partition_indexes: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: true}}
    ]

  defp request_schema(5),
    do: [
      group_id: {:string, %{is_nullable?: false}},
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partition_indexes: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: true}}
    ]

  defp request_schema(6),
    do: [
      group_id: {:compact_string, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partition_indexes: {{:compact_array, :int32}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: true}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(7),
    do: [
      group_id: {:compact_string, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partition_indexes: {{:compact_array, :int32}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: true}},
      require_stable: {:boolean, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(8),
    do: [
      groups:
        {{:compact_array,
          [
            group_id: {:compact_string, %{is_nullable?: false}},
            topics:
              {{:compact_array,
                [
                  name: {:compact_string, %{is_nullable?: false}},
                  partition_indexes: {{:compact_array, :int32}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: true}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      require_stable: {:boolean, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(9),
    do: [
      groups:
        {{:compact_array,
          [
            group_id: {:compact_string, %{is_nullable?: false}},
            member_id: {:compact_string, %{is_nullable?: true}},
            member_epoch: {:int32, %{is_nullable?: false}},
            topics:
              {{:compact_array,
                [
                  name: {:compact_string, %{is_nullable?: false}},
                  partition_indexes: {{:compact_array, :int32}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: true}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      require_stable: {:boolean, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message OffsetFetch")

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
                  committed_offset: {:int64, %{is_nullable?: false}},
                  metadata: {:string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}}
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
                  committed_offset: {:int64, %{is_nullable?: false}},
                  metadata: {:string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(2),
    do: [
      topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  committed_offset: {:int64, %{is_nullable?: false}},
                  metadata: {:string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}}
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
                  committed_offset: {:int64, %{is_nullable?: false}},
                  metadata: {:string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}}
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
                  committed_offset: {:int64, %{is_nullable?: false}},
                  metadata: {:string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}}
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
                  committed_offset: {:int64, %{is_nullable?: false}},
                  committed_leader_epoch: {:int32, %{is_nullable?: false}},
                  metadata: {:string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}}
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
                  committed_offset: {:int64, %{is_nullable?: false}},
                  committed_leader_epoch: {:int32, %{is_nullable?: false}},
                  metadata: {:compact_string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
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
                  committed_offset: {:int64, %{is_nullable?: false}},
                  committed_leader_epoch: {:int32, %{is_nullable?: false}},
                  metadata: {:compact_string, %{is_nullable?: true}},
                  error_code: {:int16, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(8),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      groups:
        {{:compact_array,
          [
            group_id: {:compact_string, %{is_nullable?: false}},
            topics:
              {{:compact_array,
                [
                  name: {:compact_string, %{is_nullable?: false}},
                  partitions:
                    {{:compact_array,
                      [
                        partition_index: {:int32, %{is_nullable?: false}},
                        committed_offset: {:int64, %{is_nullable?: false}},
                        committed_leader_epoch: {:int32, %{is_nullable?: false}},
                        metadata: {:compact_string, %{is_nullable?: true}},
                        error_code: {:int16, %{is_nullable?: false}},
                        tag_buffer: {:tag_buffer, %{}}
                      ]}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            error_code: {:int16, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(9),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      groups:
        {{:compact_array,
          [
            group_id: {:compact_string, %{is_nullable?: false}},
            topics:
              {{:compact_array,
                [
                  name: {:compact_string, %{is_nullable?: false}},
                  partitions:
                    {{:compact_array,
                      [
                        partition_index: {:int32, %{is_nullable?: false}},
                        committed_offset: {:int64, %{is_nullable?: false}},
                        committed_leader_epoch: {:int32, %{is_nullable?: false}},
                        metadata: {:compact_string, %{is_nullable?: true}},
                        error_code: {:int16, %{is_nullable?: false}},
                        tag_buffer: {:tag_buffer, %{}}
                      ]}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            error_code: {:int16, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message OffsetFetch")
end