import React, { useEffect, useState, useRef, useContext } from "react"
import { fetchNui } from "../../utils/fetchNui"
import { useVisibility } from "../../providers/VisibilityProvider"

function Skillbar({ duration = 20000, on }: { duration?: number; on?: boolean }) {
    const [status, setStatus] = useState(100)
    const intervalTime = 50
    const [value, setValue] = useState(0.0)
    const valueRef = useRef(value)

    useEffect(() => {
        if (status <= 0) {
            fetchNui("finishedSkillbar")
            setValue(0)
            setStatus(100)
        }

        valueRef.current = value
    }, [value])

    useEffect(() => {
        const step = intervalTime / duration
        const interval = setInterval(() => {
            if (!on) return

            setValue((prev) => {
                const nextValue = Math.min(prev + step, 1)
                if (nextValue === 1) clearInterval(interval)
                return nextValue
            })
        }, intervalTime)

        return () => clearInterval(interval)
    }, [duration, intervalTime, on])

    useEffect(() => {
        const interval = setInterval(() => {
            if (!on) return

            setStatus((prev) => Math.max(prev - valueRef.current, 0))
        }, 10)

        return () => clearInterval(interval)
    }, [on])

    useEffect(() => {
        const handleClick = () => {
            setStatus((prev) => Math.min(prev + 10, 100))
        }

        window.addEventListener("click", handleClick)
        return () => window.removeEventListener("click", handleClick)
    }, [])

    return (
        <div className="w-screen h-screen flex justify-center">
            <div className="h-10 self-end mb-28 opacity-95 w-80 rounded-lg bg-gradient-to-l from-green-300/95 to-red-500/95 overflow-hidden border border-slate-800">
                <div className="w-[2px] h-full rounded-xl bg-slate-800 relative" style={{ left: `${status}%` }}></div>
            </div>
        </div>
    )
}

export default Skillbar
