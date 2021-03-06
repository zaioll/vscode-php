FROM zaioll/php-nts:8.0

LABEL maintener 'Láyro Chrystofer <zaioll@protonmail.com>'

ENV usuario developer
ENV HOME /home/${usuario}
ENV VSCODEEXT /var/vscode-ext

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	git \
	--no-install-recommends

RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add - \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt-get update && apt-get -y install \
	code \
	libasound2 \
	libatk1.0-0 \
	libcairo2 \
	libcups2 \
	libexpat1 \
	libfontconfig1 \
	libfreetype6 \
	libgtk2.0-0 \
	libpango-1.0-0 \
	libx11-xcb1 \
	libxcomposite1 \
	libxcursor1 \
	libxdamage1 \
	libxext6 \
	libxfixes3 \
	libxi6 \
	libxrandr2 \
	libxrender1 \
	libxss1 \
	libxtst6 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get update && apt-get install --no-install-recommends -y yarn

RUN su ${usuario} -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"
RUN su ${usuario} -c "\. ${HOME}/.nvm/nvm.sh && nvm install --lts"

RUN mkdir ${VSCODEEXT} \
    && mkdir /var/www/html -p \
	&& chown -R ${usuario}:${usuario} ${HOME} /var/www/html \
    && chown -R ${usuario}:${usuario} $VSCODEEXT \
    && su ${usuario} -c "code --extensions-dir $VSCODEEXT --install-extension formulahendry.auto-close-tag --install-extension ymotongpoo.licenser --install-extension yzhang.markdown-all-in-one --install-extension wakatime.vscode-wakatime --install-extension esbenp.prettier-vscode --install-extension piotrpalarz.vscode-gitignore-generator --install-extension formulahendry.auto-complete-tag --install-extension vsls-contrib.codetour --install-extension coenraads.bracket-pair-colorizer --install-extension ms-vscode-remote.vscode-remote-extensionpack --install-extension felixfbecker.php-intellisense --install-extension felixfbecker.php-debug --install-extension whatwedo.twig --install-extension ikappas.phpcs --install-extension ecodes.vscode-phpmd --install-extension bmewburn.vscode-intelephense-client --install-extension MehediDracula.php-namespace-resolver --install-extension phproberto.vscode-php-getters-setters --install-extension naumovs.color-highlight --install-extension anseki.vscode-color --install-extension vscode-icons-team.vscode-icons --install-extension eamodio.gitlens --install-extension Zignd.html-css-class-completion --install-extension raynigon.nginx-formatter --install-extension mrmlnc.vscode-apache --install-extension mechatroner.rainbow-csv --install-extension jock.svg --install-extension tyriar.terminal-tabs --install-extension formulahendry.terminal --install-extension ms-vscode.vscode-typescript-tslint-plugin --install-extension mgmcdermott.vscode-language-babel --install-extension michelemelluso.code-beautifier --install-extension editorconfig.editorconfig --install-extension donjayamanne.githistory --install-extension ecmel.vscode-html-css --install-extension doublefint.pgsql --install-extension mehedidracula.php-constructor --install-extension neilbrayfield.php-docblocker --install-extension marabesi.php-import-checker --install-extension chrmarti.regex --install-extension imperez.smarty --install-extension vscodevim.vim --install-extension davidanson.vscode-markdownlint --install-extension compulim.vscode-clock --install-extension mutantdino.resourcemonitor --install-extension dotjoshjohnson.xml --install-extension visualstudioexptteam.vscodeintellicode" \
    && su ${usuario} -c "composer global require phpunit/phpunit" \
    && su ${usuario} -c "composer global require phpmd/phpmd" \
    && su ${usuario} -c "composer global require squizlabs/php_codesniffer" 

COPY start.sh /usr/local/bin/start.sh
COPY settings.json ${HOME}/.config/Code/User

RUN chown ${usuario}:${usuario} ${HOME}/.config/Code/User/settings.json

WORKDIR /var/www/html

#USER ${usuario}

CMD [ "/usr/local/bin/start.sh" ]
