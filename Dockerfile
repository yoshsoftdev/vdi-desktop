FROM alpine:3.16

LABEL maintainer="Don <novaspirit@novaspirit.com>"

RUN apk add --no-cache sudo git xfce4 faenza-icon-theme bash python3 tigervnc xfce4-terminal firefox cmake \
    pulseaudio xfce4-pulseaudio-plugin pavucontrol pulseaudio-alsa alsa-plugins-pulse alsa-lib-dev nodejs npm \
    build-base openssh-client \
    && adduser -h /home/sentrinel -s /bin/bash -S -D sentrinel && echo -e "sentrinel\nsentrinel" | passwd sentrinel \
    && echo 'sentrinel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && git clone --branch v1.5.0 --depth 1 https://github.com/novnc/noVNC /opt/noVNC \
    && git clone --branch v0.12.0 --depth 1 https://github.com/novnc/websockify /opt/noVNC/utils/websockify

# Copy local noVNC custom files
COPY script.js /opt/noVNC/script.js
COPY audify.cjs /opt/noVNC/audify.cjs
COPY vnc.html /opt/noVNC/vnc.html
COPY pcm-player.js /opt/noVNC/pcm-player.js



RUN npm install --prefix /opt/noVNC ws
RUN npm install --prefix /opt/noVNC audify

USER sentrinel
WORKDIR /home/sentrinel

RUN mkdir -p /home/sentrinel/.vnc \
    && echo -e "-Securitytypes=none" > /home/sentrinel/.vnc/config \
    && echo -e "#!/bin/bash\nstartxfce4 &" > /home/sentrinel/.vnc/xstartup \
    && echo -e "sentrinel\nsentrinel\nn\n" | vncpasswd

USER root

# copy wallpaper ke container
COPY tao.png /usr/share/backgrounds/tao.png

RUN mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml && \
    cat > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?> 
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="image-path" type="string" value="/usr/share/backgrounds/tao.png"/>
        <property name="last-image" type="string" value="/usr/share/backgrounds/tao.png"/>
        <property name="image-style" type="int" value="5"/>
      </property>
    </property>
  </property>
</channel>
EOF




# bikin entrypoint dengan wallpaper setting
RUN cat <<'EOF' > /entry.sh
#!/bin/bash
/usr/bin/vncserver :99 2>&1 | sed "s/^/[Xtigervnc ] /" &
sleep 1 &
/usr/bin/pulseaudio 2>&1 | sed "s/^/[pulseaudio] /" &
sleep 1 &
/usr/bin/node /opt/noVNC/audify.cjs 2>&1 | sed "s/^/[audify    ] /" &
/opt/noVNC/utils/novnc_proxy --vnc localhost:5999 2>&1 | sed "s/^/[noVNC     ] /"
EOF

RUN chmod +x /entry.sh

USER sentrinel

ENTRYPOINT [ "/bin/bash", "/entry.sh" ]

