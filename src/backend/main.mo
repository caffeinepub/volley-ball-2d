import Map "mo:core/Map";
import Text "mo:core/Text";
import Array "mo:core/Array";
import Order "mo:core/Order";
import Time "mo:core/Time";
import Nat "mo:core/Nat";
import Int "mo:core/Int";

actor {
  type Room = {
    hostJoined : Bool;
    guestJoined : Bool;
    state : ?Text;
    input : ?Text;
    lastUpdated : Int;
  };

  type ScoreEntry = {
    name : Text;
    score : Nat;
  };

  module ScoreEntry {
    public func compare(a : ScoreEntry, b : ScoreEntry) : Order.Order {
      Nat.compare(b.score, a.score);
    };
  };

  let rooms = Map.empty<Text, Room>();
  var highScores : [ScoreEntry] = [];
  var roomCounter : Nat = 0;

  func generateRoomCode() : Text {
    let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let charsArray : [Char] = chars.toArray();
    roomCounter += 1;
    let seed = Int.abs(Time.now()) + roomCounter * 1000;
    let a = (seed % 36);
    let b = ((seed / 37) % 36);
    let c = ((seed / 1369) % 36);
    let d = ((seed / 50653) % 36);
    Text.fromChar(charsArray[a]) # Text.fromChar(charsArray[b]) # Text.fromChar(charsArray[c]) # Text.fromChar(charsArray[d]);
  };

  public shared func createRoom() : async Text {
    let code = generateRoomCode();
    let room : Room = {
      hostJoined = true;
      guestJoined = false;
      state = null;
      input = null;
      lastUpdated = Time.now();
    };
    rooms.add(code, room);
    code;
  };

  public shared func joinRoom(code : Text) : async Bool {
    switch (rooms.get(code)) {
      case (null) { false };
      case (?room) {
        if (room.guestJoined) { return false };
        let updatedRoom = { room with guestJoined = true; lastUpdated = Time.now() };
        rooms.add(code, updatedRoom);
        true;
      };
    };
  };

  public shared func sendState(code : Text, state : Text) : async Bool {
    switch (rooms.get(code)) {
      case (null) { false };
      case (?room) {
        let updatedRoom = { room with state = ?state; lastUpdated = Time.now() };
        rooms.add(code, updatedRoom);
        true;
      };
    };
  };

  // Query = fast read, no consensus
  public query func getState(code : Text) : async ?Text {
    switch (rooms.get(code)) {
      case (null) { null };
      case (?room) { room.state };
    };
  };

  public shared func sendInput(code : Text, input : Text) : async Bool {
    switch (rooms.get(code)) {
      case (null) { false };
      case (?room) {
        let updatedRoom = { room with input = ?input; lastUpdated = Time.now() };
        rooms.add(code, updatedRoom);
        true;
      };
    };
  };

  // Query = fast read, no consensus
  public query func getInput(code : Text) : async ?Text {
    switch (rooms.get(code)) {
      case (null) { null };
      case (?room) { room.input };
    };
  };

  public query func getRoomInfo(code : Text) : async ?{ hostJoined : Bool; guestJoined : Bool } {
    switch (rooms.get(code)) {
      case (null) { null };
      case (?room) {
        ?{ hostJoined = room.hostJoined; guestJoined = room.guestJoined };
      };
    };
  };

  public shared func addScore(name : Text, score : Nat) : async () {
    let newScore = { name; score };
    let updatedScores = (highScores.concat([newScore])).sort();
    highScores := updatedScores.sliceToArray(0, Nat.min(10, updatedScores.size()));
  };

  public query func getTopScores() : async [ScoreEntry] {
    highScores;
  };
};
