let locale: any = []

export const setLocale = (newLocale: any) => {
    locale = newLocale
}

const L = (path: string, args: Map<string, string> = new Map<string, string>()) => {
    let translation = locale[path]

    if(typeof translation === "object") {
        let randomTranslation = translation[Math.floor(Math.random() * translation.length)]
        
        for (let [key, value] of args) {
            randomTranslation = randomTranslation.replace(`{${key}}`, value)
        }

        return(randomTranslation)
    }
    if(typeof translation !== "string") return path

    for (let [key, value] of args) {
        translation = translation.replace(`{${key}}`, value)
    }

    return(translation)
}

export default L