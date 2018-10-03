FROM resin/aarch64-alpine:3.5

RUN apk update \
 && apk add sudo \
 && adduser -S databox \
 && echo 'databox ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/databox \
 && chmod 440 /etc/sudoers.d/databox \
 && chown root:root /etc/sudoers.d/databox \
 && sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers

USER databox
WORKDIR /home/databox

# setup ocaml
RUN sudo apk add --no-cache --virtual .build-deps alpine-sdk bash ncurses-dev m4 perl gmp-dev zlib-dev libsodium-dev opam zeromq-dev \
&& opam init --comp 4.04.2 \
&& opam update \
&& opam pin add -n sodium https://github.com/me-box/ocaml-sodium.git#with_auth_hmac256 \
&& opam install -y reason re.1.7.1 lwt tls sodium macaroons ezirmin bitstring ppx_bitstring uuidm lwt-zmq bos oml \
