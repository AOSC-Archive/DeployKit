namespace Dk {
namespace Mirrors {

public class AoscApiMirrors : Object {
  private uint64 _ref;
  private Gee.ArrayList<Dk.Mirrors.AoscApiMirror> mirrors;

  public AoscApiMirrors() {
    _ref = 0;
    mirrors = new Gee.ArrayList<Dk.Mirrors.AoscApiMirror>();
  }

  public uint64 get_ref() {
    return this._ref;
  }

  public void set_ref(uint64 _ref) {
    this._ref = _ref;
  }

  public Gee.ArrayList<Dk.Mirrors.AoscApiMirror> get_mirrors() {
    return this.mirrors;
  }

  public void set_mirrors(Gee.ArrayList<Dk.Mirrors.AoscApiMirror> mirrors) {
    this.mirrors = mirrors;
  }
}

}
}
