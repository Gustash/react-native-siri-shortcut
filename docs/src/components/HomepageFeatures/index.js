import React from "react";
import clsx from "clsx";
import styles from "./styles.module.css";

const FeatureList = [
  {
    title: "Regular Actions",
    Svg: require("@site/static/img/icons8-shortcuts.svg").default,
    description: (
      <>
        Allow your users to add shortcuts for common and regular actions they
        take part in your app.
      </>
    ),
  },
  {
    title: "Siri Suggestions",
    Svg: require("@site/static/img/icons8-siri-color.svg").default,
    description: (
      <>
        Integrate your app with Spotlight and have iOS automatically suggest
        actions based on time and location.
      </>
    ),
  },
  {
    title: "Open Source",
    Svg: require("@site/static/img/icons8-open-source.svg").default,
    description: (
      <>
        Licensed under the MIT License,{" "}
        <code>react-native-siri-shortcut</code>{" "}
        gives you full transparency and control over it's code.
      </>
    ),
  },
];

function Feature({ Svg, title, description }) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
