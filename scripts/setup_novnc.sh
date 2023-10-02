#!/bin/sh

if [ "$NOVNC" = "false" ]; then
  return
fi

HOSTNAME=$(hostname)

# Function to generate a self-signed certificate
generate_certificate() {
  openssl req -new -x509 -days 365 -nodes \
    -out /novnc.pem -keyout novnc.pem \
    -subj "/C=US/ST=Georgia/L=Atlanta/O=PodArcade/CN=localhost"  > /dev/null 2>&1
}

# Check if novnc.pem exists, generate if not
if [ ! -f "novnc.pem" ]; then
  echo "Generating self-signed certificate..."
  generate_certificate
fi

# Launch websockify to bridge VNC server
# Assuming VNC server is running on localhost:5901
websockify -D --web /usr/share/novnc/ --cert=novnc.pem 7900 localhost:5900

# Launch noVNC in the browser
# Assuming you are running this on a headless server, you can access noVNC via https://<your-server-ip>:6080/
echo "noVNC should now be accessible via https://${HOSTNAME:-"0.0.0.0"}:7900/"