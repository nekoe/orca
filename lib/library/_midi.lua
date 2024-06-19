local midi_out = function(self, x, y)
  self.y = y
  self.x = x
  self.name = "midi"
  self.ports = { {1, 0, "in-channel"}, {2, 0, "in-octave"}, {3, 0, "in-note"}, {4, 0, "in-velocity"}, {5, 0, "in-length"} }
  self:spawn(self.ports)

  local channel = util.clamp(self:listen(self.x + 1, self.y) or 1, 1, 16)

  local octave = util.clamp(self:listen(self.x + 2, self.y) or 4, 1, 8)
  local note = self:glyph_at(self.x + 3, self.y) or "C"

  local vel = util.clamp(self:listen(self.x + 4, self.y) or 10, 1, 16)
  local length = util.clamp(self:listen(self.x + 5, self.y) or 1, 1, 36)

  local transposed = self:transpose(note, octave)
  local n, oct, velocity = transposed[1], transposed[4], math.floor((vel / 16 ) * 127)

  if self:neighbor(self.x, self.y, "*") then
    self:before_bang_midi_note_at(self.x, self.y, channel, n, length, false)
    self.midi_out_device:note_on(n, velocity, channel)
  end
end

return midi_out
