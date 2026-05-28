FROM voicevox/voicevox_engine:cpu-latest
CMD ["--host", "0.0.0.0", "--port", "50021", "--cors_policy_mode", "all"]
