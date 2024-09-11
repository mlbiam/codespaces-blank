# Kubernetes Multitenancy and Secret Management Lab


## Deployment Steps

### Deploy Kubernetes

```bash
$ cd scripts
$ ./create_cluster.sh
```

### Deploy OpenUnison

```bash
$ ./setup_openunison.sh
```

add port forwarding for ports 443, 10444, 10445.  Make public and https.

### Integrate akeyless

Create initia-admin user:

1. User & Auth Methods
2. New
3. API Key
4. Name: init-admin, Click "Finish"
5. copy access id and access key

Add init-admin to admin role:

1. Access Roles
2. admin
3. Associate
4. Choose /init-admin for Auth Method

Setup akeyless

```bash
$ akeyless
AKEYLESS-CLI, first use detected
For more info please visit: https://docs.akeyless.io/docs/cli
Enter Akeyless URL (Default: vault.akeyless.io) 
Would you like to configure a profile? (Y/n) Y
Profile Name:  (Default: default) 
Access Type (enter for access_key): 
  1) access_key 
  2) aws_iam 
  3) azure_ad 
  4) saml 
  5) ldap
  6) email/password
  7) oidc
  8) k8s
  9) gcp
  10) certificate
  11) oci
 1
Access ID:  p-************
Access Key:  ********************************************
The profile: default was successfully configured
Would you like to move 'akeyless' binary to: /home/codespace/.akeyless/bin/akeyless? (Y/n)
Please type your answer: n
```

Setup SSO with akeyless

```bash
$ cd scripts
$ ./setup_akeyless_sso.sh
```

***If you see the error `failed to create auth method: Desc: auth method creation failed, Error: Desc: Failed to create auth method. Status 400 Bad Request, Error: InvalidParam. Message: account id: acc-eml1vex0l1Tm, access id: p-vbkes1ww9i6uam. Desc: Failed to create access. Status 400 Bad Request, Error: InvalidAccessParams. Message: failed to load provider issuer`, the 443 port forwarder is not set to public***

Setup Gateway

```bash
$ cd scripts
$ ./setup_akeyless_gateway.sh
```

Add port 10446 to portforward.  Change to HTTPS, public.

```bash
Every 2.0s: kubectl get pods -n akeyless                                                                                                                                                                                                                                                                                                                                                                                 codespaces-9076fc: Tue Sep 10 14:21:16 2024

NAME                                      READY   STATUS    RESTARTS   AGE
gw-akeyless-api-gateway-7c8bcdb55-7wdxs   0/1     Running   0          2m
gw-akeyless-api-gateway-7c8bcdb55-z96bv   0/1     Running   0          2m
```

Once the gateways are running, login to the akeyless console, then:

1. Users & Auth Methods
2. openunison
3. Add `https://githubspaceshost-10446.app.github.dev/gw/login-oidc` to Allowed Redirect URIs where githubspaceshost is the name of your github codespace

Setup Kubernetes Authentication

```bash
$ cd scripts
$ ./setup_k8s_auth_cp.sh
```