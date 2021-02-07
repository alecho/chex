defmodule Chex.Acceptance.ShirovKarjakin2008Test do
  use Chex.FullGameCase, async: true

  @moves """
    1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Nd6 6. Bxc6
    dxc6 7. dxe5 Nf5 8. Qxd8+ Kxd8 9. Nc3 Ne7 10. h3 Ng6 11. Bg5+
    Ke8 12. Rad1 Bd7 13. Nd4 h6 14. Bc1 Be7 15. f4 h5 16. Rfe1 Nh4
    17. Ne4 Kf8 18. Ng5 Bxg5 19. fxg5 Ng6 20. b3 Ke8 21. e6 Bxe6
    22. Bb2 Rg8 23. Nf5 Kf8 24. Ba3+ Ke8 25. Bb2 Kf8 26. Rd7 c5
    27. Bxg7+ Ke8 28. Rxc7 Kd8 29. Rxc5 Bxf5 30. Bf6+ Kd7 31. Rxf5
    Rae8 32. Rd1+ Kc8 33. Rc5+ Kb8 34. Rd7 Rc8 35. Rxc8+ Rxc8
    36. Rxf7 Rxc2 37. Bd4 Rxa2 38. Rg7 Ra6 39. Bf6 Nh4 40. Be5+
    Kc8 41. Rc7+ Kd8 42. Rh7 1-0
  """

  setup_all do
    set_context(@moves)
  end

  test "can play Shirov v. Karjakin 2008", %{moves: moves, game: game} do
    assert {:ok, _game} = moves(game, moves)
  end
end
