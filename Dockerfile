#
# Chromedriver Dockerfile
#

FROM blueimp/basedriver

RUN apt-get install wget

# Make chromedriver available in the PATH:
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN dpkg -i google-chrome-stable_current_amd64.deb

# Install chromedriver (which depends on chromium):
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    chromedriver \
  && apt-get install libosmesa6 \
  # Start chromium via wrapper script with --no-sandbox argument:
  && mv /usr/lib/chromium/chromium /usr/lib/chromium/chromium-original \
  && printf '%s\n' '#!/bin/sh' \
    'exec /usr/lib/chromium/chromium-original --no-sandbox "$@"' \
    > /usr/lib/chromium/chromium && chmod +x /usr/lib/chromium/chromium \
  # Remove obsolete files:
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
	

# Make chromedriver available in the PATH:
RUN ln -s /usr/lib/chromium/chromedriver /usr/local/bin/

USER webdriver

CMD ["chromedriver", "--url-base=/wd/hub", "--enable-webgl-draft-extensions", "--enable-webgl-image-chromium", "--enable-gl-path-rendering", "--port=4444", "--whitelisted-ips="]
