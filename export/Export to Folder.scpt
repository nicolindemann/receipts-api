JsOsaDAS1.001.00bplist00�Vscript_�// (C)opyright 2017-04-25 Dirk Holtwick, holtwick.it. All rights reserved.

app = Application.currentApplication()
app.includeStandardAdditions = true

Receipts = new Application('Receipts')
if (Receipts) {

    // Get the data we want to export
    let jsonString = Receipts.export('items', {
        // mark: true,
        as: 'json',
    })
    let data = JSON.parse(jsonString)
	let items = data.items
	
    // let ctr = 0
    // Progress.totalUnitCount = items.length
    // Progress.description = 'Processing Items'

    let dest = "/Users/nicolindemann/Library/Mobile\ Documents/com\~apple\~CloudDocs/Receipts/Export"
    console.log('dest', dest)

    let str = $.NSString.alloc.initWithUTF8String(jsonString)
    str.writeToFileAtomically(`${dest}/Receipts.json`, true)

    for (let item of items) {

        // Create a custom file name
        let locale = 'de-de'
        let date = new Date(item.date).toLocaleDateString(locale)
        let amount = (+item.amountsOriginal.gross).toLocaleString(locale, {
            style: 'currency',
            currency: item.amountsOriginal.currency,
        })
		let provider = item.provider || {title: 'Unknown'} 
        let fileName = `${provider.title}-${date}-${amount}-${item.id.slice(0, 4)}.pdf`

        let script = `mkdir -p "${dest}/${year}/" && cp "${item.asset.path}" "${dest}/${year}/${fileName}"`
        console.log(script)
        app.doShellScript(script)
		
		script = `/usr/local/bin/tag --add rechnung "${dest}/${year}/${fileName}"`
		console.log(script)
        app.doShellScript(script)

        // console.log(fileName, item.url) 
        // Progress.completedUnitCount = ++ctr	
    }
}
else {
    console.error('Could not find Receipts')
}
                              �jscr  ��ޭ