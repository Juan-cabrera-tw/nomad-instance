resource "aws_alb" "lab_squad_alb" {
    name = "lab-squad-alb"
    subnets = [
        aws_default_subnet.default_az1.id,
        aws_default_subnet.default_az2.id,
        aws_default_subnet.default_az3.id
    ]
    security_groups = ["${aws_security_group.lab_squad_sg.id}"]
}

resource "aws_alb_target_group" "frontend-target-group" {
    name = "lab-squad-alb-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_default_vpc.default.id
}

resource "aws_alb_target_group_attachment" "frontend-attachment-1" {
    target_group_arn = "${aws_alb_target_group.frontend-target-group.arn}"
    target_id = module.nomad.instances_ids[1]
    port = 80
}

resource "aws_alb_target_group_attachment" "frontend-attachment-2" {
    target_group_arn = "${aws_alb_target_group.frontend-target-group.arn}"
    target_id = module.nomad.instances_ids[2]
    port = 80
}

resource "aws_alb_listener" "frontend-listeners" {
    load_balancer_arn = "${aws_alb.lab_squad_alb.arn}"
    port = "80"

    default_action {
      target_group_arn = "${aws_alb_target_group.frontend-target-group.arn}"
      type = "forward"
    }
}