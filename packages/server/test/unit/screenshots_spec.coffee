require("../spec_helper")

Fixtures    = require("../support/helpers/fixtures")
config      = require("#{root}lib/config")
settings    = require("#{root}lib/util/settings")
screenshots = require("#{root}lib/screenshots")

image = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAALlJREFUeNpi1F3xYAIDA4MBA35wgQWqyB5dRoaVmeHJ779wPhOM0aQtyBAoyglmOwmwM6z1lWY44CMDFgcBFmRTGp3EGGJe/WIQ5mZm4GRlBGJmhlm3PqGaeODpNzCtKsbGIARUCALvvv6FWw9XeOvrH4bbQNOQwfabnzHdGK3AwyAjyAqX2HPzC0Pn7Y9wPtyNIMGlD74wmAqwMZz+8AvFxzATVZAFQIqwABWQiWtgAY5uCnKAAwQYAPr8OZysiz4PAAAAAElFTkSuQmCC"

describe "lib/screenshots", ->
  beforeEach ->
    Fixtures.scaffold()

    @todosPath = Fixtures.projectPath("todos")

    config.get(@todosPath)
    .then (@cfg) =>

  afterEach ->
    Fixtures.remove()

  context ".take", ->
    it "outputs file and returns size and path", ->
      screenshots.take({name: "foo/tweet"}, image, @cfg.screenshotsFolder)
      .then (obj) =>
        path = @cfg.screenshotsFolder + "/footweet.png"

        expect(obj.size).to.eq("279 B")
        expect(obj.path).to.eq(path)
        expect(obj.width).to.eq(10)
        expect(obj.height).to.eq(10)

        fs.statAsync(path)

  context ".copy", ->
    it "doesnt yell over ENOENT errors", ->
      screenshots.copy("/does/not/exist", "/foo/bar/baz")

    it "copies src to des with {overwrite: true}", ->
      @sandbox.stub(fs, "copyAsync").withArgs("foo", "bar", {overwrite: true}).resolves()

      screenshots.copy("foo", "bar")