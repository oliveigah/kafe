# DO NOT EDIT THIS FILE MANUALLY  
# This module is automatically generated by running mix task generate_file
# every change must be done inside the mix task directly

defmodule KlifeProtocol.Messages.AddPartitionsToTxn do
  @moduledoc """
  Kafka protocol AddPartitionsToTxn message

  Request versions summary:   
  - Version 1 is the same as version 0.
  - Version 2 adds the support for new error code PRODUCER_FENCED.
  - Version 3 enables flexible versions.
  - Version 4 adds VerifyOnly field to check if partitions are already in transaction and adds support to batch multiple transactions.
  Versions 3 and below will be exclusively used by clients and versions 4 and above will be used by brokers.

  Response versions summary:
  - Starting in version 1, on quota violation brokers send out responses before throttling.
  - Version 2 adds the support for new error code PRODUCER_FENCED.
  - Version 3 enables flexible versions.
  - Version 4 adds support to batch multiple transactions and a top level error code.

  """

  alias KlifeProtocol.Deserializer
  alias KlifeProtocol.Serializer
  alias KlifeProtocol.Header

  @api_key 24
  @min_flexible_version_req 3
  @min_flexible_version_res 3

  @doc """
  Content fields:

  - transactions: List of transactions to add partitions to. ([]AddPartitionsToTxnTransaction | versions 4+)
      - transactional_id: The transactional id corresponding to the transaction. (string | versions 4+)
      - producer_id: Current producer id in use by the transactional id. (int64 | versions 4+)
      - producer_epoch: Current epoch associated with the producer id. (int16 | versions 4+)
      - verify_only: Boolean to signify if we want to check if the partition is in the transaction rather than add it. (bool | versions 4+)
      - topics: The partitions to add to the transaction. ([]AddPartitionsToTxnTopic | versions 4+)
          - name: The name of the topic. (string | versions 0+)
          - partitions: The partition indexes to add to the transaction ([]int32 | versions 0+)
  - v3_and_below_transactional_id: The transactional id corresponding to the transaction. (string | versions 0-3)
  - v3_and_below_producer_id: Current producer id in use by the transactional id. (int64 | versions 0-3)
  - v3_and_below_producer_epoch: Current epoch associated with the producer id. (int16 | versions 0-3)
  - v3_and_below_topics: The partitions to add to the transaction. ([]AddPartitionsToTxnTopic | versions 0-3)
      - name: The name of the topic. (string | versions 0+)
      - partitions: The partition indexes to add to the transaction ([]int32 | versions 0+)

  """
  def serialize_request(%{headers: headers, content: content}, version) do
    headers
    |> Map.put(:request_api_key, @api_key)
    |> Map.put(:request_api_version, version)
    |> Header.serialize_request(req_header_version(version))
    |> then(&Serializer.execute(content, request_schema(version), &1))
  end

  @doc """
  Content fields:

  - throttle_time_ms: Duration in milliseconds for which the request was throttled due to a quota violation, or zero if the request did not violate any quota. (int32 | versions 0+)
  - error_code: The response top level error code. (int16 | versions 4+)
  - results_by_transaction: Results categorized by transactional ID. ([]AddPartitionsToTxnResult | versions 4+)
      - transactional_id: The transactional id corresponding to the transaction. (string | versions 4+)
      - topic_results: The results for each topic. ([]AddPartitionsToTxnTopicResult | versions 4+)
          - name: The topic name. (string | versions 0+)
          - results_by_partition: The results for each partition ([]AddPartitionsToTxnPartitionResult | versions 0+)
  - results_by_topic_v3_and_below: The results for each topic. ([]AddPartitionsToTxnTopicResult | versions 0-3)
      - name: The topic name. (string | versions 0+)
      - results_by_partition: The results for each partition ([]AddPartitionsToTxnPartitionResult | versions 0+)

  """
  def deserialize_response(data, version) do
    {headers, rest_data} = Header.deserialize_response(data, res_header_version(version))
    {content, <<>>} = Deserializer.execute(rest_data, response_schema(version))

    %{headers: headers, content: content}
  end

  def max_supported_version(), do: 4
  def min_supported_version(), do: 0

  defp req_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_req, do: 2, else: 1)

  defp res_header_version(msg_version),
    do: if(msg_version >= @min_flexible_version_res, do: 1, else: 0)

  defp request_schema(0),
    do: [
      v3_and_below_transactional_id: {:string, %{is_nullable?: false}},
      v3_and_below_producer_id: {:int64, %{is_nullable?: false}},
      v3_and_below_producer_epoch: {:int16, %{is_nullable?: false}},
      v3_and_below_topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(1),
    do: [
      v3_and_below_transactional_id: {:string, %{is_nullable?: false}},
      v3_and_below_producer_id: {:int64, %{is_nullable?: false}},
      v3_and_below_producer_epoch: {:int16, %{is_nullable?: false}},
      v3_and_below_topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(2),
    do: [
      v3_and_below_transactional_id: {:string, %{is_nullable?: false}},
      v3_and_below_producer_id: {:int64, %{is_nullable?: false}},
      v3_and_below_producer_epoch: {:int16, %{is_nullable?: false}},
      v3_and_below_topics:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            partitions: {{:array, :int32}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp request_schema(3),
    do: [
      v3_and_below_transactional_id: {:compact_string, %{is_nullable?: false}},
      v3_and_below_producer_id: {:int64, %{is_nullable?: false}},
      v3_and_below_producer_epoch: {:int16, %{is_nullable?: false}},
      v3_and_below_topics:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            partitions: {{:compact_array, :int32}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(4),
    do: [
      transactions:
        {{:compact_array,
          [
            transactional_id: {:compact_string, %{is_nullable?: false}},
            producer_id: {:int64, %{is_nullable?: false}},
            producer_epoch: {:int16, %{is_nullable?: false}},
            verify_only: {:boolean, %{is_nullable?: false}},
            topics:
              {{:compact_array,
                [
                  name: {:compact_string, %{is_nullable?: false}},
                  partitions: {{:compact_array, :int32}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, []}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, []}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, []}
    ]

  defp request_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message AddPartitionsToTxn")

  defp response_schema(0),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      results_by_topic_v3_and_below:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            results_by_partition:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  partition_error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(1),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      results_by_topic_v3_and_below:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            results_by_partition:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  partition_error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(2),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      results_by_topic_v3_and_below:
        {{:array,
          [
            name: {:string, %{is_nullable?: false}},
            results_by_partition:
              {{:array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  partition_error_code: {:int16, %{is_nullable?: false}}
                ]}, %{is_nullable?: false}}
          ]}, %{is_nullable?: false}}
    ]

  defp response_schema(3),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      results_by_topic_v3_and_below:
        {{:compact_array,
          [
            name: {:compact_string, %{is_nullable?: false}},
            results_by_partition:
              {{:compact_array,
                [
                  partition_index: {:int32, %{is_nullable?: false}},
                  partition_error_code: {:int16, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(4),
    do: [
      throttle_time_ms: {:int32, %{is_nullable?: false}},
      error_code: {:int16, %{is_nullable?: false}},
      results_by_transaction:
        {{:compact_array,
          [
            transactional_id: {:compact_string, %{is_nullable?: false}},
            topic_results:
              {{:compact_array,
                [
                  name: {:compact_string, %{is_nullable?: false}},
                  results_by_partition:
                    {{:compact_array,
                      [
                        partition_index: {:int32, %{is_nullable?: false}},
                        partition_error_code: {:int16, %{is_nullable?: false}},
                        tag_buffer: {:tag_buffer, %{}}
                      ]}, %{is_nullable?: false}},
                  tag_buffer: {:tag_buffer, %{}}
                ]}, %{is_nullable?: false}},
            tag_buffer: {:tag_buffer, %{}}
          ]}, %{is_nullable?: false}},
      tag_buffer: {:tag_buffer, %{}}
    ]

  defp response_schema(unkown_version),
    do: raise("Unknown version #{unkown_version} for message AddPartitionsToTxn")
end