# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.DescribeTopicPartitions do
  @moduledoc """
  Kafka protocol DescribeTopicPartitions message

  Request versions summary:   

  Response versions summary:

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 75
  @min_flexible_version_req 0
  @min_flexible_version_res 0

  @doc """
  Receives a map and serialize it to kafka wire format of the given version.

  Input content fields:
  - topics: The topics to fetch details for. ([]TopicRequest | versions 0+)
      - name: The topic name (string | versions 0+)
  - response_partition_limit: The maximum number of partitions included in the response. (int32 | versions 0+)
  - cursor: The first topic and partition index to fetch details for. (Cursor | versions 0+)
      - topic_name: The name for the first topic to process (string | versions 0+)
      - partition_index: The partition index to start with (int32 | versions 0+)

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

  - throttle_time_ms: The duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 0+)
  - topics: Each topic in the response. ([]DescribeTopicPartitionsResponseTopic | versions 0+)
      - error_code: The topic error, or 0 if there was no error. (int16 | versions 0+)
      - name: The topic name. (string | versions 0+)
      - topic_id: The topic id. (uuid | versions 0+)
      - is_internal: True if the topic is internal. (bool | versions 0+)
      - partitions: Each partition in the topic. ([]DescribeTopicPartitionsResponsePartition | versions 0+)
          - error_code: The partition error, or 0 if there was no error. (int16 | versions 0+)
          - partition_index: The partition index. (int32 | versions 0+)
          - leader_id: The ID of the leader broker. (int32 | versions 0+)
          - leader_epoch: The leader epoch of this partition. (int32 | versions 0+)
          - replica_nodes: The set of all nodes that host this partition. ([]int32 | versions 0+)
          - isr_nodes: The set of nodes that are in sync with the leader for this partition. ([]int32 | versions 0+)
          - eligible_leader_replicas: The new eligible leader replicas otherwise. ([]int32 | versions 0+)
          - last_known_elr: The last known ELR. ([]int32 | versions 0+)
          - offline_replicas: The set of offline replicas of this partition. ([]int32 | versions 0+)
      - topic_authorized_operations: 32-bit bitfield to represent authorized operations for this topic. (int32 | versions 0+)
  - next_cursor: The next topic and partition index to fetch details for. (Cursor | versions 0+)
      - topic_name: The name for the first topic to process (string | versions 0+)
      - partition_index: The partition index to start with (int32 | versions 0+)

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
  def max_supported_version(), do: 0

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
      topics:
        {{:compact_array,
          [name: {:compact_string, %{is_nullable?: false}}, tag_buffer: {:tag_buffer, []}]},
         %{is_nullable?: false}},
      response_partition_limit: {:int32, %{is_nullable?: false}},
      cursor:
        {{:object,
          [
            topic_name: {:compact_string, %{is_nullable?: false}},
            partition_index: {:int32, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: true}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message DescribeTopicPartitions")

  defp response_schema(0),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      topics:
        {{:compact_array,
          [
            error_code: {:int16, %{is_nullable?: false}},
            name: {:compact_string, %{is_nullable?: true}},
            topic_id: {:uuid, %{is_nullable?: false}},
            is_internal: {:boolean, %{is_nullable?: false}},
            partitions:
              {{:compact_array,
                [
                  error_code: {:int16, %{is_nullable?: false}},
                  partition_index: {:int32, %{is_nullable?: false}},
                  leader_id: {:int32, %{is_nullable?: false}},
                  leader_epoch: {:int32, %{is_nullable?: false}},
                  replica_nodes: {{:compact_array, :int32}, %{is_nullable?: false}},
                  isr_nodes: {{:compact_array, :int32}, %{is_nullable?: false}},
                  eligible_leader_replicas: {{:compact_array, :int32}, %{is_nullable?: true}},
                  last_known_elr: {{:compact_array, :int32}, %{is_nullable?: true}},
                  offline_replicas: {{:compact_array, :int32}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            topic_authorized_operations: {:int32, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      next_cursor:
        {{:object,
          [
            topic_name: {:compact_string, %{is_nullable?: false}},
            partition_index: {:int32, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: true}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message DescribeTopicPartitions")
end