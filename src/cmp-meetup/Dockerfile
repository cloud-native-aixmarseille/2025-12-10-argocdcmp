FROM quay.io/argoproj/argocd:v3.2.0

USER root
COPY * /argocd-cmp/
RUN chown -R argocd:argocd /argocd-cmp && \
    apt-get update -y && \
    apt-get install -y curl jq && \
    apt-get clean

USER argocd

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD argocd version --client
