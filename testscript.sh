if true; then
      # test if schematics plugin is installed
      echo "attempting to locate schematics plugin..."
      if ! ibmcloud plugin list | grep schematics; then
        ibmcloud plugin install schematics -f
      fi

      echo '{' \
        "    \"name\": \"$WORKSPACE_NAME\"," \
        '    "type": [' \
        '      "terraform-v1.0"' \
        '    ],' \
        '    "description": "the description",' \
        '    "tags": [],' \
        '    "template_repo": {' \
        '      "url": "https://github.com/triceam/cluster"' \
        '    },' \
        '    "template_data": [' \
        '      {' \
        '        "folder": ".",' \
        '        "type": "terraform-v1.0",' \
        '        "values": "",' \
        '        "variablestore": [' \
        '           {' \
        '               "name": "ibmcloud_api_key", ' \
        "               \"value\": \"$API_KEY\" " \
        '           }' \
        '       ]' \
        '      }' \
        '    ]' \
        '  }' > workspace-template.json
      
      ibmcloud terraform workspace new -f workspace-template.json -g $GITHUB_TOKEN
fi


workspaces="$(ibmcloud terraform workspace list | grep "$WORKSPACE_NAME")"
tokens=( $workspaces )
workspace_id="${tokens[1]}"
echo $workspace_id

ibmcloud terraform apply -i $workspace_id --force