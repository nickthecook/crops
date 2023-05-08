module Builtins
  module Helpers
    module Templates
      TEMPLATES = { "ops" => OPS_TEMPLATE, "terraform" => TERRAFORM_TEMPLATE, "ruby" => RUBY_TEMPLATE }

      OPS_TEMPLATE = <<-OPS_TEMPLATE
      dependencies:
        # e.g.
        # brew:
          # - docker-compose
          # - docker
          # - curl
      actions:
        start:
          command: docker-compose up -d
          description: starts the service
        stop:
          command: docker-compose down
          description: stops the service
      
      OPS_TEMPLATE
      TERRAFORM_TEMPLATE = <<-TERRAFORM_TEMPLATE
      dependencies:
        brew:
          - terraform
        apt:
          - terraform
        custom:
          - terraform init
      actions:
        apply:
          command: terraform apply
          alias: a
          description: runs 'terraform apply'
        apply-auto-approve:
          command: ops apply --auto-approve
          alias: aa
          description: runs 'terraform apply' with auto-approve
        destroy:
          command: terraform destroy
          alias: d
          description: runs 'terraform destroy'
        destroy-auto-approve:
          command: ops destroy --auto-approve
          alias: dd
          description: runs 'terraform destroy' with auto-approve
        plan:
          command: terraform plan
          alias: p
          description: runs 'terraform plan'
        graph:
          command: terraform graph | dot -T pdf -o resource_graph.pdf
          alias: g
          description: runs 'terraform graph'
        open-graph:
          command: ops graph && open resource_graph.pdf
          alias: og
          description: opens the terraform graph with the OS 'open' command
      
      TERRAFORM_TEMPLATE
      RUBY_TEMPLATE = <<-RUBY_TEMPLATE
      dependencies:
        gem:
          - bundler
          - rerun
        custom:
          - bundle
      actions:
        start:
          command: echo update me
          description: starts the app
        stop:
          command: echo update me too
          description: stops the app
        test:
          command: rspec
          alias: t
          description: runs unit tests
        test-watch:
          command: rerun -x ops test
          alias: tw
          description: runs unit tests every time a file changes
        lint:
          command: bundle exec rubocop --safe-auto-correct
          alias: l
          description: runs rubocop with safe autocorrect
        build:
          command: gem build *.gemspec
          alias: b
          description: builds the gem
        install:
          command: gem install `ls -t *.gem | head -n1`
          alias: i
          description: installs the gem
        build-and-install:
          command: ops build && ops install
          alias: bi
          description: builds and installs the gem
      
      RUBY_TEMPLATE
    end
  end
end
