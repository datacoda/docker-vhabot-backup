dataferret/vhabot-backup
========================

Sidecar Docker container for Anarchy Online Vhabot.  It's assumes that /var/lib/vhabot/config.d
is located on a volume container to which this backup container will be granted volume access.


Usage
-----

Just start up the container.

        docker run -d --name vhabot-backup --restart=always \
            --volumes-from vhabot-data \
            -e REMOTE_URL=s3+http://mys3bucket/vhabot/ \
            -e AWS_ACCESS_KEY_ID=key \
            -e AWS_SECRET_ACCESS_KEY=secret \
            -e PASSPHRASE
            dataferret/vhabot-backup

It's scheduled to do daily incremental backups.  Weekly full backups. There is currently no
cleaning nor removal of older backup sets.

Notes
-----

Tested only with s3 buckets.
