# Pattern Matching in Ruby with the Pokemon TCG

I came up with this to demonstrate some of the pattern matching features of
Ruby. I'd perhaps like to challenge myself to implement some subset of the
Pokemon TCG in Ruby at some point, but really, this was a means of capturing
some of the pattern matching features of Ruby and spreading the word!

So, without further ado...

## A pinch of context

The Pokemon trading card game has a variety of game actions you can take, but
recently, searching your deck has become quite significant. Lots of cards let
you search for different things, whether that's a Pokemon of any kind, a Rapid
Strike card, or the more powerful Pokemon V.

This repo makes a little effort to make some structures that might form part of
a game engine for the TCG, but most importantly, it implements deck searching,
returning any valid targets along with the rest of your deck. And in order to do
so, it uses inline Ruby pattern matching!

## Where's the fun stuff?

Take a look in `lib/pokemon_tcg/card`. This is where the magic happens.

I've defined behavior for three different cards:

- **Adventurer's Discovery**, whose effect is to *search your deck for Pokemon
  V*. Pokemon V, Pokemon VSTAR, and Pokemon VMAX are all considered to be
  Pokemon V when you're searching your deck. Their names end in `V`, `VMAX` and
  `VSTAR`, such as `Omastar V`, `Inteleon VMAX`, and `Drapion VSTAR`.
- **Level Ball**, whose effect is to *search your deck for a Pokemon with 90 HP
  or less*.
- **Octillery**, whose Rapid Strike Search ability lets you search your deck for
  one Rapid Strike card. Rapid Strike is one of several Battle Styles,
  introduced in the set of the same name. It's a marker that goes on cards from
  Energy to Supporters and Pokemon - any of those are valid search targets as
  long as they're Rapid Strike cards! But there's nothing stopping Pokemon
  from printing a card with multiple Battle Styles, like Deoxys.

## Which pattern matching features do we need to use to grab what we want?

### Adventurer's Discovery

Adventurer's Discovery finds us Pokemon V, VSTAR, and VMAX. We can use a regex
for that, `/V(STAR|MAX)?$/`, and feed it right into a pattern matcher:

```rb
irb(main):001:0> 'Leafeon' in /V(STAR|MAX)?$/
=> false
irb(main):002:0> 'Leafeon V' in /V(STAR|MAX)?$/
=> true
```

`in`, like `when` in a case statement, plays nicely with regex. But that's just
the start!

Cards have more attributes than just their names, so when we're filtering
through the deck with a block, we can actually pass it as a hash. So we do
something more like this in the code:

```rb
deck.partition { |card| card in { name: /V(STAR|MAX)?$/ } }
```

Of course, cards are Ruby objects, [as they should
be](https://refactoring.guru/smells/primitive-obsession)...so this won't work
right out of the gate. We need to define `deconstruct_keys(keys)` on
`PokemonTCG::Card`.

### Level Ball

Level Ball finds us Pokemon with under 90HP. Pokemon are the only things that
have HP\*, so we can just match on whatever's got 90HP or less. `in` lets us do
that with a range:

```rb
deck.partition { |card| card in { hp: ..90 } }
```

### Octillery

Now we've got something a little more funky with pattern matching. This is
what's called a *find pattern*, and it's a bit experimental right now. As we
mentioned before, Deoxys is a valid search target for Octillery because it's a
Rapid Strike card, so what we want to check is that each card has Rapid Strike
among its Battle Styles. For this, we need to check that the `battle_styles`
array for each card has `:rapid_strike` in its midst.

\*at least until before they're out of the deck and on the bench!
