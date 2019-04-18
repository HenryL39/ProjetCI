package com.lesformateurs;

/**
 * This is a class.
 */
public class Greeter {

  /**
   * This is a constructor.
   */
  public Greeter() {

  }

  final public String greet(final String someone) {
    return String.format("Hello, %s!", someone);
  }
}
