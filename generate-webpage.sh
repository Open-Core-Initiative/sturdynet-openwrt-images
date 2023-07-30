#!/bin/bash

PUBLIC=${1:-public}

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
	<meta charset="UTF-8" />
    	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Sturdynet Image Downloads</title>
	<style>
	      body {
	        font-family: "Courier New", monospace;
	        background-color: #f0f0f0;
	        color: #333;
	        display: flex;
	        flex-direction: column;
	        align-items: center;
	        min-height: 100vh;
	        margin: 0;
	      }
	
	      pre {
	        font-size: 16px;
	      }
	
	      @media (max-width: 768px) {
	        pre {
	          font-size: 12px;
	        }
	      }
	
	      .ascii-table {
	        margin-top: 5px;
	        font-size: 20px;
	        text-align: center;
	        border-collapse: collapse;
	      }
	
	      .ascii-table th,
	      .ascii-table td {
	        padding: 5px;
	        border: 1px dashed #333;
	      }
	
	      .ascii-table th {
	        background-color: #f0f0f0;
	      }
	
	      .ascii-table ul:not(:last-child) {
	        border-bottom: 1px dashed #333;
	      }
	
	      .ascii-table ul {
	        list-style-type: none; /* Remove bullets */
	        padding: 5px; /* Remove padding */
	        margin: 5px; /* Remove margins */
	      }
	    </style>
</head>
<body>
	<pre>
    _____   _   _   _____   _       _       ___   _____   _   _   _   _ 
  /  ___| | | | | /  ___| | |     | |     /   | | ____| | \ | | | \ | |
  | |     | | | | | |     | |     | |    / /| | | |__   |  \| | |  \| |
  | |     | | | | | |     | |     | |   / / | | |  __|  |     | |     |
  | |___  | |_| | | |___  | |___  | |  / /  | | | |___  | |\  | | |\  |
  \_____| \___/   \_____| |_____| |_| /_/   |_| |_____| |_| \_| |_| \_|
 	</pre>
	<table class="ascii-table">
	      <tr>
	        <th>Downloads</th>
	      </tr>
	      <tr>
	        <td>
END

for I in images/*; do

cat <<END
	<ul>
$(makeLink "		" ${I})
	</ul>
END

done

cat <<END
	</td>
      </tr>
    </table>
</body>
</html>
END
