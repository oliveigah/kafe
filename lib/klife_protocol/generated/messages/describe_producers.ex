# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.DescribeProducers do
  @moduledoc """
  Kafka protocol DescribeProducers message

  Request versions summary:   

  Response versions summary:

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 61
  @min_flexible_version_req 0
  @min_flexible_version_res 0

  @doc """
  Valid fields:

  - topics:  ([]TopicRequest | versions 0+)
  - name: The topic name. (string | versions 0+) 
  - partition_indexes: The indexes of the partitions to list producers for. ([]int32 | versions 0+) 

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
  - topics: Each topic in the response. ([]TopicResponse | versions 0+)
      - name: The topic name (string | versions 0+)
      - partitions: Each partition in the response. ([]PartitionResponse | versions 0+)
          - partition_index: The partition index. (int32 | versions 0+)
          - error_code: The partition error code, or 0 if there was no error. (int16 | versions 0+)
          - error_message: The partition error message, which may be null if no additional details are available (string | versions 0+)
          - active_producers:  ([]ProducerState | versions 0+)
              - producer_id:  (int64 | versions 0+)
              - producer_epoch:  (int32 | versions 0+)
              - last_sequence:  (int32 | versions 0+)
              - last_timestamp:  (int64 | versions 0+)
              - coordinator_epoch:  (int32 | versions 0+)
              - current_txn_start_offset:  (int64 | versions 0+)

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
      topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partition_indexes: {{:compact_array, :int32}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp response_schema(0),
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
                  error_message: {:compact_string, %{is_nullable?: true}},
                  active_producers:
                    {{:compact_array,
                      [
                        producer_id: {:int64, %{is_nullable?: false}},
                        producer_epoch: {:int32, %{is_nullable?: false}},
                        last_sequence: {:int32, %{is_nullable?: false}},
                        last_timestamp: {:int64, %{is_nullable?: false}},
                        coordinator_epoch: {:int32, %{is_nullable?: false}},
                        current_txn_start_offset: {:int64, %{is_nullable?: false}},
                        tag_buffer: {:tag_buffer, %{}}
                      ]}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]
end