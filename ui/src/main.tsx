import React, { useEffect, useState, ReactNode, ErrorInfo } from "react"
import ReactDOM from "react-dom/client"
import "./index.css"
import SkillBar from "./components/SkillBar/SkillBar"
import { useNuiEvent } from "./hooks/useNuiEvent"
import { VisibilityProvider } from "./providers/VisibilityProvider"

function HandleComponent() {
    const [duration, setDuration] = useState(20000)
    const [on, setOn] = useState(false)

    useNuiEvent("skillbar", (data: { duration: number; on: boolean }) => {
        setOn(data.on)
        setDuration(data.duration)
    })

    return <SkillBar duration={duration} on={on} />
}

ReactDOM.createRoot(document.getElementById("root")!).render(
    <VisibilityProvider>
        <HandleComponent />
    </VisibilityProvider>
)
