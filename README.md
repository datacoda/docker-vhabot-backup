dataferret/vhabot-backup
========================

Sidecar Docker container for Anarchy Online Vhabot.  It's assumes that /var/lib/vhabot/config.d
is located on a volume container to which this backup container will be granted volume access.

Duplicity installation based off
[cjhardekopf/duplicity](https://github.com/cjhardekopf/docker-duplicity)


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

You can also invoke a backup (full or incremental) at anytime via exec.

        docker exec -it vhabot-backup backup full

A restore script is also provided that will move the contents of the existing config.d
folder to /var/backup and pull down the latest from the duplicity set.

        docker exec -it vhabot-backup restore


Notes
-----

Tested only with US Standard S3 buckets.

This is mostly a cobbled together a proof of concept that works fine for my needs.  If you have
any specific needs that aren't met - like another S3 region or backend, feel free to fork and
file a feature issue.
