$ORIGIN example.com.

; TTL of 10 minutes for quick change during competitions
$TTL    600

; hostmaster.example.com. is the email hostmaster@example.com
@       IN      SOA     ns1.example.com. hostmaster.example.com. (
							1       ; Serial
							600     ; Refresh
							600     ; Retry
							2419200 ; Expire
							600     ; Negative Cache TTL (how long to cache negative (e.g. NXDOMAIN) responses)
						)
		IN      NS      ns1         ; this box
		IN      MX  10  mail        ; mail box
		IN      A       10.0.0.103  ; www box (resolve example.com to the same address as www.example.com)

ns1     IN      A       10.0.0.101
mail    IN      A       10.0.0.102
www     IN      A       10.0.0.103
