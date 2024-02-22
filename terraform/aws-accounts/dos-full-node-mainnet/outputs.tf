output "terraformer_access_key_id" {
  value = module.iam_user_terraformer.access_key_id
}

output "terraformer_access_key_secret" {
  value = module.iam_user_terraformer.access_key_secret
  sensitive = true
}
