FROM voicevox/voicevox_engine:cpu-latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends nginx curl && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '/opt/voicevox_engine/run --host 127.0.0.1 --port 50021 --cors_policy_mode all &' >> /start.sh && \
    echo 'echo "VOICEVOX 시작, 15초 대기..."' >> /start.sh && \
    echo 'sleep 15' >> /start.sh && \
    echo 'echo "기본 6개 speaker 워밍업..."' >> /start.sh && \
    echo 'for id in 3 2 8 14 13 12; do' >> /start.sh && \
    echo '  echo "  Loading speaker $id..."' >> /start.sh && \
    echo '  curl -s -X POST "http://127.0.0.1:50021/initialize_speaker?speaker=$id" > /dev/null || true' >> /start.sh && \
    echo 'done' >> /start.sh && \
    echo 'echo "워밍업 완료, nginx 시작"' >> /start.sh && \
    echo 'exec nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT []
EXPOSE 8080
CMD ["/start.sh"]
