# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.ElectLeaders do
  @moduledoc """
  Kafka protocol ElectLeaders message

  Request versions summary:   
  - Version 1 implements multiple leader election types, as described by KIP-460.
  - Version 2 is the first flexible version.

  Response versions summary:
  - Version 1 adds a top-level error code.
  - Version 2 is the first flexible version.

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 43
  @min_flexible_version_req 2
  @min_flexible_version_res 2

  @doc """
  Valid fields:

  - election_type: Type of elections to conduct for the partition. A value of '0' elects the preferred replica. A value of '1' elects the first live replica if there are no in-sync replica. (int8 | versions 1+)
  - topic_partitions: The topic partitions to elect leaders. ([]TopicPartitions | versions 0+)
  - topic: The name of a topic. (string | versions 0+) 
  - partitions: The partitions of this topic whose leader should be elected. ([]int32 | versions 0+) 
  - timeout_ms: The time in ms to wait for the election to complete. (int32 | versions 0+)

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

  - throttle_time_ms: The duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 0+)
  - error_code: The top level response error code. (int16 | versions 1+)
  - replica_election_results: The election results, or an empty array if the requester did not have permission and the request asks for all partitions. ([]ReplicaElectionResult | versions 0+)
      - topic: The topic name (string | versions 0+)
      - partition_result: The results for each partition ([]PartitionResult | versions 0+)
          - partition_id: The partition id (int32 | versions 0+)
          - error_code: The result error, or zero if there was no error. (int16 | versions 0+)
          - error_message: The result message, or null if there was no error. (string | versions 0+)

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
      topic_partitions:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: true}},
      timeout_ms: {:int32, %{is_nullable?: false}}
    ]

  defp request_schema(1),
    do: [
      election_type: {:int8, %{is_nullable?: false}},
      topic_partitions:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: true}},
      timeout_ms: {:int32, %{is_nullable?: false}}
    ]

  defp request_schema(2),
    do: [
      election_type: {:int8, %{is_nullable?: false}},
      topic_partitions:
        {{:compact_array,
          [
            topic: {:compact_string, %{is_nullable?: false}},
            partitions: {{:compact_array, :int32}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: true}},
      timeout_ms: {:int32, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp response_schema(0),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      replica_election_results:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partition_result:
              {{:array,
                [
                  partition_id: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  error_message: {:string, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(1),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      replica_election_results:
        {{:array,
          [
            topic: {:string, %{is_nullable?: false}},
            partition_result:
              {{:array,
                [
                  partition_id: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  error_message: {:string, %{is_nullable?: true}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(2),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      replica_election_results:
        {{:compact_array,
          [
            topic: {:compact_string, %{is_nullable?: false}},
            partition_result:
              {{:compact_array,
                [
                  partition_id: {:int32, %{is_nullable?: false}},
                  error_code: {:int16, %{is_nullable?: false}},
                  error_message: {:compact_string, %{is_nullable?: true}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]
end