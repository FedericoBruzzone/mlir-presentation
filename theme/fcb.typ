// =============================================================================
// FCB Presentation Theme Library
// A simple Typst library for creating presentations
// =============================================================================

// -----------------------------------------------------------------------------
// State variables
// -----------------------------------------------------------------------------
#let _background-state = state("fcb-background", white)
#let _foreground-state = state("fcb-foreground", black)
#let _link-background-state = state("fcb-link-background", blue)
#let _header-footer-foreground-state = state("fcb-header-footer-foreground", gray)
#let _header-state = state("fcb-header", none)
#let _footer-state = state("fcb-footer", none)


// -----------------------------------------------------------------------------
// Utility functions
// -----------------------------------------------------------------------------

// Side-by-side layout helper using grid
#let side-by-side(columns: auto, gutter: 1em, ..bodies) = {
  let bodies-list = bodies.pos()
  let col-widths = if columns == auto {
    (1fr,) * bodies-list.len()
  } else {
    columns
  }
  grid(
    columns: col-widths,
    gutter: gutter,
    ..bodies-list
  )
}

// -----------------------------------------------------------------------------
// Slide templates
// -----------------------------------------------------------------------------

// Title slide - for the presentation opening
#let title-slide(body) = {
  pagebreak(weak: true)
  page(
    header: none,
    footer: none,
    align(horizon + center, body)
  )
}

// Simple slide - basic content slide with header/footer
#let simple-slide(body) = {
  pagebreak(weak: true)
  align(top + left, body)
}

// Centered slide - content centered both horizontally and vertically, no header/footer
#let centered-slide(body) = {
  pagebreak(weak: true)
  page(
    header: none,
    footer: none,
    align(horizon + center, body)
  )
}

// Focus slide - like centered-slide but with inverted colors
#let focus-slide(body) = {
  pagebreak(weak: true)
  context {
    let fg = _foreground-state.get()
    let bg = _background-state.get()
    page(
      fill: fg,
      header: none,
      footer: none,
      {
        set text(fill: bg)
        show heading: it => text(fill: bg, it.body)
        align(horizon + center, body)
      }
    )
  }
}

// -----------------------------------------------------------------------------
// Main theme function
// -----------------------------------------------------------------------------
#let fcb-theme(
  aspect-ratio: "16-9",
  header: none,
  footer: none,
  background: white,
  foreground: black,
  link-background: blue,
  header-footer-foreground: gray,
  body,
) = {
  // Update state
  _background-state.update(background)
  _foreground-state.update(foreground)
  _link-background-state.update(link-background)
  _header-footer-foreground-state.update(header-footer-foreground)
  _header-state.update(header)
  _footer-state.update(footer)

  // Page setup
  set page(
    paper: "presentation-" + aspect-ratio,
    fill: background,
    margin: (top: 2.5em, bottom: 2em, left: 1.5em, right: 1.5em),
    header: context {
      let h = _header-state.get()
      if h != none {
        text(
          size: 0.6em,
          fill: _header-footer-foreground-state.get(),
          h
        )
      }
    },
    footer: context {
      let f = _footer-state.get()
      text(
        size: 0.5em,
        fill: _header-footer-foreground-state.get(),
        grid(
          columns: (1fr, auto),
          align: (left, right),
          if f != none { f } else { [] },
          counter(page).display("1 / 1", both: true),
        )
      )
    },
    header-ascent: 1em,
    footer-descent: 1em,
  )

  // Text setup
  set text(
    fill: foreground,
    size: 23pt,
  )

  // Heading styles - all bold
  show heading.where(level: 1): it => {
    text(weight: "bold", it.body)
  }

  show heading.where(level: 2): it => {
    text(weight: "bold", it.body)
  }

  show heading.where(level: 3): it => {
    text(weight: "bold", it.body)
  }

  show heading.where(level: 4): it => {
    text(weight: "bold", it.body)
  }

  show heading.where(level: 5): it => {
    text(weight: "bold", it.body)
  }

  show heading.where(level: 6): it => {
    text(weight: "bold", it.body)
  }

  // Emphasize numbers
  show cite: it => {
    show regex("\d"): set text(_link-background-state .get())
    it
  }


  // Show links
  show link: this => {
    let show-type = "underline"
    let label-color = foreground // A label is something like: <a> or #label("a")
    let default-color = link-background

    if show-type == "box" {
      if type(this.dest) == label {
        // Make the box bound the entire text:
        set text(bottom-edge: "bounds", top-edge: "bounds")
        box(this, stroke: label-color + 1pt)
      } else {
        set text(bottom-edge: "bounds", top-edge: "bounds")
        box(this, stroke: default-color + 1pt)
      }
    } else if show-type == "filled" {
      if type(this.dest) == label {
        text(this, fill: label-color)
      } else {
        text(this, fill: default-color)
      }
    } else if show-type == "underline" {
      if type(this.dest) == label {
          let this = text(this, fill: label-color)
          underline(this, stroke: label-color)
      } else {
          let this = text(this, fill: default-color)
          underline(this, stroke: default-color)
      }
    } else {
      this
    }
  }

  // List styling
  set list(
    indent: 0.5em,
    body-indent: 0.5em,
    marker: text(fill: foreground, "•"),
  )

  set enum(
    indent: 0.5em,
    body-indent: 0.5em,
  )

  // Paragraph settings
  set par(
    justify: false,
    leading: 0.65em,
  )

  // Footnote styling
  show footnote.entry: set text(size: 0.5em)
  set footnote.entry(gap: 0.3em)

  body
}
