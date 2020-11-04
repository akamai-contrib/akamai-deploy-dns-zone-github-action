# akamai-deploy-dns-zone-github-action
GitHub Action which deploys DNS zone files to Akamai's Edge DNS via DNS API calls

<img src="https://developer.akamai.com/assets/img/developer-experience-logo.png" alt="akamai developer experience logo" width="200"/>

**Important Note**: please copy the YAML syntax from **this README file** (see "workflow.yml Example" section below) into your action YAML and update the "zoneName" parameter to match your DNS domain

# Deploy DNS zone to Akamai Edge DNS   

This action calls the [Akamai DNS API](https://developer.akamai.com/api/cloud_security/edge_dns_zone_management/v2.html) to deploy a DNS zone file into the corresponding Akamai EDGE DNS zone.

## Usage

Setup your repository with the following file:
```
<repository name>
            - [domain.zone]
```

For example if your DNS domain is "example.com" you should have a file called "example.com.zone" containing the DNS records. See [DNS Zone File](https://en.wikipedia.org/wiki/Zone_file) for reference.

A DNS zone file would look something like this:
```
example.com.  IN  SOA   ns.example.com. username.example.com. ( 2007120710 1d 2h 4w 1h )
example.com.  IN  NS    ns                    ; ns.example.com is a nameserver for example.com
example.com.  IN  NS    ns.somewhere.example. ; ns.somewhere.example is a backup nameserver for example.com
example.com.  IN  MX    10 mail.example.com.  ; mail.example.com is the mailserver for example.com
example.com.  IN  A     192.0.2.1             ; IPv4 address for example.com
              IN  AAAA  2001:db8:10::1        ; IPv6 address for example.com
ns            IN  A     192.0.2.2             ; IPv4 address for ns.example.com
              IN  AAAA  2001:db8:10::2        ; IPv6 address for ns.example.com
www           IN  CNAME example.com.          ; www.example.com is an alias for example.com
mail          IN  A     192.0.2.3             ; IPv4 address for mail.example.com
```

## Secrets

All sensitive variables should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) in the action's configuration.

You need to declare an `EDGERC` secret in your repository containing the following structure :
```
[dns]
client_secret = your_client_secret
host = your_host
access_token = your_access_token
client_token = your_client_token
```

You can retrieve these from [Akamai Control Center](https://control.akamai.com/) >> Identity Management >> API User.

## Inputs

### `zoneName` (**Required**)
DNS Zone name: the name of your DNS domain ('example.com' in our example)

## workflow.yml Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```yaml
steps:
    - uses: actions/checkout@v2
    - name: Deploy DNS zone file
      uses: akamai-contrib/akamai-deploy-dns-zone-github-action@1.3
      env:
        EDGERC: ${{ secrets.EDGERC }}
      with:
        zoneName: 'example.com' # replace with the name of your domain
```

## License

Copyright 2020 Akamai Technologies, Inc.

See [Apache License 2.0](LICENSE)

By submitting a contribution (the “Contribution”) to this project, and for good and valuable consideration, the receipt and sufficiency of which are hereby acknowledged, you (the “Assignor”) irrevocably convey, transfer, and assign the Contribution to the owner of the repository (the “Assignee”), and the Assignee hereby accepts, all of your right, title, and interest in and to the Contribution along with all associated copyrights, copyright registrations, and/or applications for registration and all issuances, extensions and renewals thereof (collectively, the “Assigned Copyrights”). You also assign all of your rights of any kind whatsoever accruing under the Assigned Copyrights provided by applicable law of any jurisdiction, by international treaties and conventions and otherwise throughout the world.
