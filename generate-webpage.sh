#!/bin/bash

IFS=$'\n'
PUBLIC=${1:-public}
URL="http://${CI_PROJECT_NAMESPACE}.gitlab.io/${CI_PROJECT_NAME}/"

function makeLink() {
	SPACE=${1}
	shift
	for I in $*; do
		BASENAME=${I##*/}
		echo "${SPACE}<li><a href=\"${I}\">${BASENAME}</a></li>"
	done
}

cd "${PUBLIC}"

cat <<END
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>${CI_PROJECT_NAME}, ${CI_COMMIT_REF_NAME}/${CI_COMMIT_SHA}</title>
	<link rel="stylesheet" href="https://www.google.com/css/maia.css">
</head>
<body>
	<h1>${CI_PROJECT_NAME}</h1>
	<p>
		<a href="${CI_PROJECT_URL}/tree/${CI_COMMIT_REF_NAME}">${CI_COMMIT_REF_NAME}</a> build
		on <em>$(date -R)</em>,
		commit <a href="${CI_PROJECT_URL}/commit/${CI_COMMIT_SHA}">${CI_COMMIT_SHA}</a>
	</p>
END

for I in images/*; do

cat <<END
	<ul>
$(makeLink "		" ${I})
	</ul>
END

done

cat <<END
	<h2>Development</h2>
	<ul>
		<li><a href="${CI_PROJECT_URL}">source-code repository</a><br /><code>git clone ${CI_PROJECT_URL}.git</code></li>
	</ul>
	<h2>License</h2>
	<pre>$(cat LICENSE | tr -d '<>&')</pre>
</body>
</html>
END
