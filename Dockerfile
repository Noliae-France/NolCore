FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates tar clang libpq-dev libsodium-dev libssl-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /tmp/nolc && curl -fsSL https://noliae-nolc.s3.gra.io.cloud.ovh.net/nolc-latest-linux-x86_64.tar.gz | tar -xzf - --strip-components=1 -C /tmp/nolc
COPY vendor/nolc/lib /nolc/lib
COPY *.nol *.nhtml /app/
COPY static /app/static
WORKDIR /app
RUN install -m 0755 /tmp/nolc/nolc /usr/local/bin/nolc && for vue in accueil login inscription recherche tableau; do nolc nhtml "$vue.nhtml"; done && nolc build main.nol -o nolcore --lien pq --lien sodium --lien ssl --lien crypto --chemin-lib /usr/lib/x86_64-linux-gnu
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 libsodium23 libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build /app/nolcore /app/nolcore
WORKDIR /app
WORKDIR /app
COPY main.nol accueil.nhtml ./
RUN nolc nhtml accueil.nhtml && nolc build main.nol -o nolcore --lien pq --chemin-lib /usr/lib/x86_64-linux-gnu
EXPOSE 8080
CMD ["/app/nolcore"]
