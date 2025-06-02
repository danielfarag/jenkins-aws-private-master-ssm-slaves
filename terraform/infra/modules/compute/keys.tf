# resource "aws_key_pair" "own" {
#   key_name   = "own"
#   public_key = file(var.public_ssh_key) 
# }