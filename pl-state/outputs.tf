output "s3_bucket_arn" {
  value       = aws_s3_bucket.pipeline_magic_state.arn
  description = "The ARN of the S3 bucket where terraform state is written"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.pipelie_magic_locks.name
  description = "The name of the DynamoDB table for managing the terrform lock"
}
