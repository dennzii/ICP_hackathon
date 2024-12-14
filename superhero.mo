import Text "mo:base/Text";
import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Result "mo:base/Result";

actor{

  public type SuperHero = {
    name : Text;
    superpowers : List.List<Text>;
  };

  //bir tip oluşturduk
  public type superheroID = Nat32;

  private stable var next : superheroID = 0;

  private stable var superheroes : Trie.Trie<superheroID,SuperHero> = Trie.empty();
  
  public func createHero (newHero : SuperHero) : async Nat32{
      let id = next;
      next += 1;

      superheroes := Trie.replace(superheroes,
      key(id),
      Nat32.equal,
      ?newHero
      ).0;

      return id;
  };



  private func key(x:superheroID) : Trie.Key<superheroID>{
    return {hash = x; key = x};
  };
      
  public func getHero(id:superheroID) : async ?SuperHero{
      let result = Trie.find(superheroes,
      key(id),
      Nat32.equal);

      return result;
  };

  public func updateHero(id:superheroID,newHero:SuperHero) : async Bool{
     let result = Trie.find(superheroes,
      key(id),
      Nat32.equal);

      let exists = Option.isSome(result);

      if(exists){
        superheroes := Trie.replace(superheroes,
            key(id),
            Nat32.equal,
            ?newHero
            ).0;
      };

      return exists
  };

}
