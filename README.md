# Sway on Pod-Arcade

## Usage

The Pod-Arcade Sway container can be accessed via VNC using port 6900:5900. For web access, port-forward 7900:7900 to use noVNC. When using this with pod-arcade, this port isn't needed, as you'll access it through the `pod-arcade/server` webpage.

### Running with Hardware Acceleration

Use this command to run the container with hardware acceleration. It requires mounting the `/dev/dri` directory to `/host/dev/dri` in the container.

```shell
docker run --rm \
 -it \
 --name "pod-arcade-sway" \
 --privileged \
 -v /dev/dri:/host/dev/dri \
 -p 6900:5900 \
 ghcr.io/pod-arcade/sway
```

### Running Without Hardware Acceleration

Use this command to run the container without hardware acceleration.

```shell
docker run --rm \
 -it \
 --name "pod-arcade-sway" \
 --privileged \
 -p 6900:5900 \
 ghcr.io/pod-arcade/sway
```

## Hardware Acceleration Configuration

The container's behavior for hardware acceleration depends on the mounted volumes:

### MKNOD Mode

- Mount Path: /dev/dri -> /host/dev/dri/
- Requires CAP_MKNOD capability.
- Best for high compatibility and shared mount paths.
- Recreates device nodes inside the container with 777 permissions.

### ADD_GROUP Mode
***NOTE: If you're using the ADD_GROUP mode, you must specifically set `DRI_DEVICE_MODE=ADD_GROUP`. This is to prevent accidentally enabling hardware acceleration when none was requested. When running docker in privileged mode, it automatically mounts the GPU device into the container.***
- Mount Path: /dev/dri -> /dev/dri/
- No special permissions needed.
- Creates new groups inside the container with the same GID as the host, and adds the ubuntu user to them.
- Suitable for single-container setups.
- Not ideal for multi-container environments with shared GPU access.

## Environment Variables
Set custom resolutions for the container (default is 1280x720):

```sh
export RESOLUTION="1280x720"
```