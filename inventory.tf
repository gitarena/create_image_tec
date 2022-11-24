resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
      ip          = aws_instance.sistema.public_ip
      id          = aws_instance.sistema.id      
  })
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
}