import type { Principal } from "@icp-sdk/core/principal";
export interface Some<T> {
    __kind__: "Some";
    value: T;
}
export interface None {
    __kind__: "None";
}
export type Option<T> = Some<T> | None;
export interface ScoreEntry {
    name: string;
    score: bigint;
}
export interface backendInterface {
    addScore(name: string, score: bigint): Promise<void>;
    createRoom(): Promise<string>;
    getInput(code: string): Promise<string | null>;
    getRoomInfo(code: string): Promise<{
        guestJoined: boolean;
        hostJoined: boolean;
    } | null>;
    getState(code: string): Promise<string | null>;
    getTopScores(): Promise<Array<ScoreEntry>>;
    joinRoom(code: string): Promise<boolean>;
    sendInput(code: string, input: string): Promise<boolean>;
    sendState(code: string, state: string): Promise<boolean>;
}
