FROM couchdb:latest

# Set environment variables
ENV COUCHDB_USER=${COUCHDB_USER}
ENV COUCHDB_PASSWORD=${COUCHDB_PASSWORD}

# Create necessary directories
RUN mkdir -p /opt/couchdb/data && \
    mkdir -p /opt/couchdb/etc

# Copy configuration file
COPY local.ini /opt/couchdb/etc/local.ini

# Set ownership for CouchDB user
RUN chown -R couchdb:couchdb /opt/couchdb/data && \
    chown -R couchdb:couchdb /opt/couchdb/etc

# Expose port
EXPOSE 5984

# Add health check with authentication
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@localhost:5984/_up || exit 1

# Use the default CouchDB entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/couchdb/bin/couchdb"]