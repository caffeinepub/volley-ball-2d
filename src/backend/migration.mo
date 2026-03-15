import Map "mo:core/Map";
import Text "mo:core/Text";
import Array "mo:core/Array";
import Order "mo:core/Order";
import Nat "mo:core/Nat";

module {
  type OldActor = {
    highScores : [ScoreEntry];
  };

  type ScoreEntry = {
    name : Text;
    score : Nat;
  };

  type Room = {
    hostJoined : Bool;
    guestJoined : Bool;
    state : ?Text;
    input : ?Text;
    lastUpdated : Int;
  };

  module ScoreEntry {
    public func compare(a : ScoreEntry, b : ScoreEntry) : Order.Order {
      Nat.compare(b.score, a.score);
    };
  };

  type NewActor = {
    rooms : Map.Map<Text, Room>;
    highScores : [ScoreEntry];
  };

  public func run(old : OldActor) : NewActor {
    let newRooms = Map.empty<Text, Room>();
    {
      rooms = newRooms;
      highScores = old.highScores;
    };
  };
};
