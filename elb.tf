# resource "aws_elb" "lab_squad_elb" {
#     name = "lab-squad-elb"
#     subnets = [
#         aws_default_subnet.default_az1.id,
#         aws_default_subnet.default_az2.id,
#         aws_default_subnet.default_az3.id
#     ]
#     security_groups = ["${aws_security_group.lab_squad_sg.id}"]

#     listener {
#         instance_port = 9999
#         instance_protocol = "http"
#         lb_port = 80
#         lb_protocol = "http"
#     }

#     health_check {
#         healthy_threshold   = 2
#         unhealthy_threshold = 2
#         timeout             = 3
#         target              = "HTTP:80/"
#         interval            = 30
#     }

#     # instances = ["${module.nomad.nomad.id}"]
#     instances = module.nomad.instances_ids
# }