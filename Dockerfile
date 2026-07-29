FROM debian:bookworm-slim AS compiler
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates tar && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/nolc && curl -fsSL https://noliae-nolc.s3.gra.io.cloud.ovh.net/nolc-latest-linux-x86_64.tar.gz | tar -xzf - --strip-components=1 -C /opt/nolc
RUN curl -fsSL https://codeload.github.com/Noliae-France/nolc/tar.gz/refs/heads/main | tar -xzf - --strip-components=1 -C /opt/nolc
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=compiler /opt/nolc/nolc /usr/local/bin/nolc
COPY --from=compiler /opt/nolc/lib "/Noliae Lang/lib"
WORKDIR /app
COPY main.nol accueil.nhtml ./
RUN nolc nhtml accueil.nhtml && nolc build main.nol -o nolcore --lien pq --chemin-lib /usr/lib/x86_64-linux-gnu
EXPOSE 8080
CMD ["/app/nolcore"]
