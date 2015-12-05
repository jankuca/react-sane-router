
npm run build

for exampleName in examples/* ; do
  if [ -d "$exampleName" ]; then
    echo ""
    echo ">> Build $exampleName"
    ./node_modules/.bin/cjsx -b -c -o "$exampleName/lib" "$exampleName/src"
    ./node_modules/.bin/webpack "$exampleName/lib/main.js" "$exampleName/lib/main.compiled.js"
  fi
done
