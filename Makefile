.PHONY: clean down perms rmq-perms run start kill

NAME ?= rabbitmq-server-7253

clean: down perms
	docker container rm $(NAME)
	rm -rf $(CURDIR)/var-lib-rabbitmq/mnesia
	rm -f $(CURDIR)/var-lib-rabbitmq/.erlang.cookie
	rm -rf $(CURDIR)/var-log-rabbitmq/*

down:
	docker stop $(NAME)

kill:
	docker kill $(NAME)

perms:
	sudo chown -R "$(USER):$(USER)" $(CURDIR)

rmq-perms:
	sudo chown -R "999:999" $(CURDIR)/var-*-rabbitmq

start: rmq-perms
	docker start --attach --interactive $(NAME)

run: rmq-perms
	docker run --pull always --name $(NAME) --publish 5672:5672 --publish 15672:15672 \
		--mount type=bind,source="$(CURDIR)/var-lib-rabbitmq",target=/var/lib/rabbitmq \
		--mount type=bind,source="$(CURDIR)/var-log-rabbitmq",target=/var/log/rabbitmq \
		--mount type=bind,source="$(CURDIR)/rabbitmq.conf",target=/etc/rabbitmq/rabbitmq.conf,readonly \
		rabbitmq:3-management
