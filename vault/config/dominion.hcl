/*
 * Vault configuration. See: https://www.vaultproject.io/docs/configuration
 */

storage "consul" {
    address = "127.0.0.1:8500"
}

listener "tcp" {
    /*
     * By default Vault listens on localhost only.
     * Make sure to enable TLS support otherwise.
     */
    address = "0.0.0.0:8200"
    tls_disable = 1
}

api_addr = "http://dominion.qkroode.nl:8200"
