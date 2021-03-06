
module TT
  BB_LEFT_FRONT_BOTTOM    ||=  0
  BB_RIGHT_FRONT_BOTTOM   ||=  1
  BB_LEFT_BACK_BOTTOM     ||=  2
  BB_RIGHT_BACK_BOTTOM    ||=  3
  BB_LEFT_FRONT_TOP       ||=  4
  BB_RIGHT_FRONT_TOP      ||=  5
  BB_LEFT_BACK_TOP        ||=  6
  BB_RIGHT_BACK_TOP       ||=  7

  BB_CENTER_FRONT_BOTTOM  ||=  8
  BB_CENTER_BACK_BOTTOM   ||=  9
  BB_CENTER_FRONT_TOP     ||= 10
  BB_CENTER_BACK_TOP      ||= 11

  BB_LEFT_CENTER_BOTTOM   ||= 12
  BB_LEFT_CENTER_TOP      ||= 13
  BB_RIGHT_CENTER_BOTTOM  ||= 14
  BB_RIGHT_CENTER_TOP     ||= 15

  BB_LEFT_FRONT_CENTER    ||= 16
  BB_RIGHT_FRONT_CENTER   ||= 17
  BB_LEFT_BACK_CENTER     ||= 18
  BB_RIGHT_BACK_CENTER    ||= 19

  BB_LEFT_CENTER_CENTER   ||= 20
  BB_RIGHT_CENTER_CENTER  ||= 21
  BB_CENTER_FRONT_CENTER  ||= 22
  BB_CENTER_BACK_CENTER   ||= 23
  BB_CENTER_CENTER_TOP    ||= 24
  BB_CENTER_CENTER_BOTTOM ||= 25

  BB_CENTER_CENTER_CENTER ||= 26
  BB_CENTER               ||= 26

  # UI.messagebox Constants
  # @since 2.4.0

  MB_ICONHAND         ||= 0x00000010
  MB_ICONSTOP         ||= 0x00000010
  MB_ICONERROR        ||= 0x00000010
  MB_ICONQUESTION     ||= 0x00000020
  MB_ICONEXCLAMATION  ||= 0x00000030
  MB_ICONWARNING      ||= 0x00000030
  MB_ICONASTERISK     ||= 0x00000040
  MB_ICONINFORMATION  ||= 0x00000040
  MB_ICON_NONE        ||= 80

  MB_DEFBUTTON1 ||= 0x00000000
  MB_DEFBUTTON2 ||= 0x00000100
  MB_DEFBUTTON3 ||= 0x00000200
  MB_DEFBUTTON4 ||= 0x00000300

  # PolygonMesh
  # @since 2.5.0

  MESH_SHARP        ||=  0
  MESH_SOFT         ||=  4
  MESH_SMOOTH       ||=  8
  MESH_SOFT_SMOOTH  ||= 12

  # view.draw_points
  # @since 2.5.0

  POINT_OPEN_SQUARE     ||= 1
  POINT_FILLED_SQUARE   ||= 2
  POINT_CROSS           ||= 3
  POINT_X               ||= 4
  POINT_STAR            ||= 5
  POINT_OPEN_TRIANGLE   ||= 6
  POINT_FILLED_TRIANGLE ||= 7

end # if TT::System.platform_supported?
