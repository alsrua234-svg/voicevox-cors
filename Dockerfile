FROM voicevox/voicevox_engine:cpu-latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends nginx && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '/opt/voicevox_engine/run --host 127.0.0.1 --port 50021 --cors_policy_mode all &' >> /start.sh && \
    echo 'sleep 5' >> /start.sh && \
    echo 'exec nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT []
EXPOSE 8080
CMD ["/start.sh"]
