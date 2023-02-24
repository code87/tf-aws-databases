# Database module for Terraform

Provisions AWS RDS PostgreSQL database instance.

Module acceps username and password stored in AWS Secrets Manager.

Database is encrypted with a given AWS KMS Customer-managed key.

Final snanshot will be created on destroy if given `environment` is `prod`.

Module provisions Security Group that allow access to database within the given VPC only.

Database instance parameters:
* Engine: PostgreSQL 13.4
* Accessible from public: no
* Multi-AZ: no
* Automatic minor version upgrades: no
* Storage type: GP2


## Variables

* `project` 
* `environment` (`staging` or `prod`)
* `db_instance_class` (default: `db.t4g.micro`)
* `db_name`
* `db_credentials_secret`
* `kms_key`
* `deletion_protection` (default: `false`)
* `allocated_storage` (default: 20 Gb)


## Outputs

* `db_endpoint`
* `db_instance_class`
* `postgresql_sg_id`


## TODO

* automated backups
* more documentation
